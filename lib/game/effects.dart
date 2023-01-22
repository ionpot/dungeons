import 'package:dungeons/game/armor.dart';
import 'package:dungeons/game/effect.dart';
import 'package:dungeons/game/effect_bonus.dart';
import 'package:dungeons/game/feat.dart';
import 'package:dungeons/game/spell.dart';
import 'package:dungeons/game/weapon.dart';
import 'package:dungeons/utility/bonus_text.dart';
import 'package:dungeons/utility/dice.dart';
import 'package:dungeons/utility/if.dart';
import 'package:dungeons/utility/percent.dart';
import 'package:dungeons/utility/range.dart';

typedef EffectBonusMap = Map<Effect, EffectBonus>;
typedef GetEffectBonus<T extends Object> = T? Function(EffectBonus);

class Effects {
  final EffectBonusMap contents;

  Effects([EffectBonusMap? m]) : contents = m ?? {};

  factory Effects.copy(Effects other) {
    return Effects(Map.of(other.contents));
  }

  int get reservedStress {
    int sum = 0;
    for (final effect in contents.keys) {
      sum += effect.reservedStress ?? 0;
    }
    return sum;
  }

  bool has(Effect effect) => contents.containsKey(effect);

  void add(Effect effect) {
    final bonus = effect.bonus ?? const EffectBonus();
    if (effect.stacks) {
      contents.update(
        effect,
        (b) => b + bonus,
        ifAbsent: () => bonus,
      );
    } else {
      contents[effect] = bonus;
    }
  }

  void remove(Effect effect) => contents.remove(effect);

  void addWeapon(Weapon weapon) => add(Effect(weapon: weapon));
  void removeWeapon(Weapon weapon) => remove(Effect(weapon: weapon));

  void addArmor(Armor armor) => add(Effect(armor: armor));
  void removeArmor(Armor armor) => remove(Effect(armor: armor));

  void addFeat(Feat feat) => add(Effect(feat: feat));
  bool hasFeat(Feat feat) => has(Effect(feat: feat));

  void addSpell(Spell spell) => add(Effect(spell: spell));
  bool hasSpell(Spell spell) => has(Effect(spell: spell));

  void clearSpells() {
    contents.removeWhere((key, value) => key.spell != null);
  }

  Effect? findEffect(GetEffectBonus<bool> f) {
    for (final entry in contents.entries) {
      if (f(entry.value) == true) {
        return entry.key;
      }
    }
    return null;
  }

  IntEffects toIntEffects(GetEffectBonus<int> f) {
    final EffectMap<int> map = {};
    for (final entry in contents.entries) {
      ifdef(f(entry.value), (value) {
        map[entry.key] = value;
      });
    }
    return IntEffects(map);
  }

  PercentEffects toPercentEffects(GetEffectBonus<Percent> f) {
    final EffectMap<Percent> map = {};
    for (final entry in contents.entries) {
      ifdef(f(entry.value), (value) {
        map[entry.key] = value;
      });
    }
    return PercentEffects(map);
  }
}

class IntEffects {
  final EffectMap<int> contents;

  IntEffects([EffectMap<int>? contents]) : contents = contents ?? {};

  bool get isEmpty => contents.isEmpty;

  int get total => contents.values.fold(0, (sum, value) => sum + value);

  void add(Effect effect, int value) {
    contents[effect] = value;
  }

  @override
  String toString() => isEmpty ? "" : bonusText(total);
}

class PercentEffects {
  final EffectMap<Percent> contents;

  const PercentEffects([this.contents = const {}]);

  bool get isEmpty => contents.isEmpty;

  Percent get total {
    return contents.values.fold(
      const Percent(),
      (sum, value) => sum + value,
    );
  }
}

class DiceEffects {
  final EffectMap<Dice> contents;

  DiceEffects([EffectMap<Dice>? contents]) : contents = contents ?? {};

  bool get isEmpty => contents.isEmpty;

  int get maxTotal => Dice.maxTotal(contents.values);
  Range get range => Dice.totalRange(contents.values);

  void add(Effect effect, Dice dice) {
    contents[effect] = dice;
  }

  DiceRollEffects roll() => _map((dice) => dice.roll());
  DiceRollEffects rollMax() => _map((dice) => dice.rollMax());

  DiceRollEffects _map(DiceRoll Function(Dice) fn) {
    return DiceRollEffects(contents.map((key, value) {
      return MapEntry(key, fn(value));
    }));
  }

  @override
  String toString() => contents.values.fold("", (str, dice) => "$str+$dice");
}

class DiceRollEffects {
  final EffectMap<DiceRoll> contents;

  const DiceRollEffects([this.contents = const {}]);

  IntEffects get totals {
    return IntEffects(contents.map((key, value) {
      return MapEntry(key, value.total);
    }));
  }
}

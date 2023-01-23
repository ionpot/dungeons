import 'package:dungeons/game/armor.dart';
import 'package:dungeons/game/bonus.dart';
import 'package:dungeons/game/effect.dart';
import 'package:dungeons/game/feat.dart';
import 'package:dungeons/game/spell.dart';
import 'package:dungeons/game/weapon.dart';
import 'package:dungeons/utility/bonus_text.dart';
import 'package:dungeons/utility/dice.dart';
import 'package:dungeons/utility/if.dart';
import 'package:dungeons/utility/percent.dart';
import 'package:dungeons/utility/range.dart';

typedef EffectMap = BonusMap<Effect>;
typedef GetEffect<T extends Object> = T? Function(Effect);

class Bonuses {
  final EffectMap contents;

  Bonuses([EffectMap? m]) : contents = m ?? {};

  factory Bonuses.copy(Bonuses other) {
    return Bonuses(Map.of(other.contents));
  }

  int get reservedStress {
    int sum = 0;
    for (final bonus in contents.keys) {
      sum += bonus.reservedStress ?? 0;
    }
    return sum;
  }

  bool has(Bonus bonus) => contents.containsKey(bonus);

  void add(Bonus bonus) {
    final effect = bonus.effect ?? const Effect();
    if (bonus.stacks) {
      contents.update(
        bonus,
        (b) => b + effect,
        ifAbsent: () => effect,
      );
    } else {
      contents[bonus] = effect;
    }
  }

  void remove(Bonus bonus) => contents.remove(bonus);

  void addWeapon(Weapon weapon) => add(Bonus(weapon: weapon));
  void removeWeapon(Weapon weapon) => remove(Bonus(weapon: weapon));

  void addArmor(Armor armor) => add(Bonus(armor: armor));
  void removeArmor(Armor armor) => remove(Bonus(armor: armor));

  void addFeat(Feat feat) => add(Bonus(feat: feat));
  bool hasFeat(Feat feat) => has(Bonus(feat: feat));

  void addSpell(Spell spell) => add(Bonus(spell: spell));
  bool hasSpell(Spell spell) => has(Bonus(spell: spell));

  void clearSpells() {
    contents.removeWhere((key, value) => key.spell != null);
  }

  Bonus? findBonus(GetEffect<bool> f) {
    for (final entry in contents.entries) {
      if (f(entry.value) == true) {
        return entry.key;
      }
    }
    return null;
  }

  IntBonuses toIntBonuses(GetEffect<int> f) {
    final BonusMap<int> map = {};
    for (final entry in contents.entries) {
      ifdef(f(entry.value), (value) {
        map[entry.key] = value;
      });
    }
    return IntBonuses(map);
  }

  PercentBonuses toPercentBonuses(GetEffect<Percent> f) {
    final BonusMap<Percent> map = {};
    for (final entry in contents.entries) {
      ifdef(f(entry.value), (value) {
        map[entry.key] = value;
      });
    }
    return PercentBonuses(map);
  }
}

class IntBonuses {
  final BonusMap<int> contents;

  IntBonuses([BonusMap<int>? contents]) : contents = contents ?? {};

  bool get isEmpty => contents.isEmpty;

  int get total => contents.values.fold(0, (sum, value) => sum + value);

  void add(Bonus effect, int value) {
    contents[effect] = value;
  }

  @override
  String toString() => isEmpty ? "" : bonusText(total);
}

class PercentBonuses {
  final BonusMap<Percent> contents;

  const PercentBonuses([this.contents = const {}]);

  bool get isEmpty => contents.isEmpty;

  Percent get total {
    return contents.values.fold(
      const Percent(),
      (sum, value) => sum + value,
    );
  }
}

class DiceBonuses {
  final BonusMap<Dice> contents;

  DiceBonuses([BonusMap<Dice>? contents]) : contents = contents ?? {};

  bool get isEmpty => contents.isEmpty;

  int get maxTotal => Dice.maxTotal(contents.values);
  Range get range => Dice.totalRange(contents.values);

  void add(Bonus bonus, Dice dice) {
    contents[bonus] = dice;
  }

  DiceRollBonuses roll() => _map((dice) => dice.roll());
  DiceRollBonuses rollMax() => _map((dice) => dice.rollMax());

  DiceRollBonuses _map(DiceRoll Function(Dice) fn) {
    return DiceRollBonuses(contents.map((key, value) {
      return MapEntry(key, fn(value));
    }));
  }

  @override
  String toString() => contents.values.fold("", (str, dice) => "$str+$dice");
}

class DiceRollBonuses {
  final BonusMap<DiceRoll> contents;

  const DiceRollBonuses([this.contents = const {}]);

  IntBonuses get totals {
    return IntBonuses(contents.map((key, value) {
      return MapEntry(key, value.total);
    }));
  }
}

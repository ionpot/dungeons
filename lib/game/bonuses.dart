import 'package:dungeons/game/armor.dart';
import 'package:dungeons/game/bonus.dart';
import 'package:dungeons/game/effect.dart';
import 'package:dungeons/game/feat.dart';
import 'package:dungeons/game/spell.dart';
import 'package:dungeons/game/weapon.dart';
import 'package:dungeons/utility/bonus_text.dart';
import 'package:dungeons/utility/dice.dart';
import 'package:dungeons/utility/multiplier.dart';
import 'package:dungeons/utility/percent.dart';
import 'package:dungeons/utility/range.dart';

typedef EffectMap = BonusMap<Effect>;

class BonusEntry {
  final Bonus bonus;
  final Effect effect;

  BonusEntry(MapEntry<Bonus, Effect> entry)
      : bonus = entry.key,
        effect = entry.value;
}

typedef GetValue<T extends Object> = T? Function(BonusEntry);

class Bonuses {
  final EffectMap contents;

  Bonuses([EffectMap? m]) : contents = m ?? {};

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

  void addAll(Bonuses other) {
    contents.addAll(other.contents);
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

  Bonus? findBonus(GetValue<bool> toBool) {
    for (final entry in contents.entries) {
      if (toBool(BonusEntry(entry)) == true) {
        return entry.key;
      }
    }
    return null;
  }

  BonusMap<T> toMap<T extends Object>(GetValue<T> toValue) {
    final BonusMap<T> output = {};
    for (final entry in contents.entries) {
      final value = toValue(BonusEntry(entry));
      if (value != null) {
        output[entry.key] = value;
      }
    }
    return output;
  }
}

class IntBonuses {
  final BonusMap<int> contents;

  const IntBonuses([this.contents = const {}]);

  bool get isEmpty => contents.isEmpty;

  int get total => contents.values.fold(0, (sum, value) => sum + value);

  IntBonuses operator +(IntBonuses other) {
    final map = Map.of(contents);
    for (final entry in other.contents.entries) {
      map.update(
        entry.key,
        (value) => value + entry.value,
        ifAbsent: () => entry.value,
      );
    }
    return IntBonuses(map);
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

class MultiplierBonuses {
  final BonusMap<Multiplier> contents;

  const MultiplierBonuses([this.contents = const {}]);

  bool get isEmpty => contents.isEmpty;

  Multiplier get total {
    return contents.values.fold(
      const Multiplier(0),
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

  BonusMap<Dice> findWithSides(int sides) {
    return Map.fromEntries([
      for (final entry in contents.entries)
        if (entry.value.sides == sides) entry,
    ]);
  }

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

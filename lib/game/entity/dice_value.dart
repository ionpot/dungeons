import "package:dungeons/game/entity/bonus.dart";
import "package:dungeons/game/entity/bonus_map.dart";
import "package:dungeons/game/entity/bonuses.dart";
import "package:dungeons/game/entity/dice_bonuses.dart";
import "package:dungeons/game/entity/value.dart";
import "package:dungeons/utility/dice.dart";
import "package:dungeons/utility/monoids.dart";
import "package:dungeons/utility/range.dart";

class DiceValue {
  final Dice base;
  final DiceBonuses diceBonuses;
  final Bonuses<Int> intBonuses;
  final Bonus? max;

  DiceValue({
    required this.base,
    DiceBonuses? diceBonuses,
    Bonuses<Int>? intBonuses,
    this.max,
  })  : diceBonuses = diceBonuses ?? DiceBonuses.empty(),
        intBonuses = intBonuses ?? Bonuses.empty();

  void addDice(Bonus bonus, Dice dice) {
    diceBonuses.add(bonus, dice);
  }

  Range get range {
    return base.range + diceBonuses.range + intBonuses.total.value;
  }

  Value<Int> get diceCountValue {
    return Value.from(
      Int(base.count),
      Bonuses.fromMap(
        diceBonuses
            .findWithSides(base.sides)
            .mapValues((value) => Int(value.count)),
      ),
    );
  }

  Value<Int> get intBonusValue => Value.from(Int(base.bonus), intBonuses);
  String get intBonusString => intBonusValue.total.signed;
  int get maxTotal => base.max + diceBonuses.maxTotal + intBonuses.total.value;
  String get sideText => base.sideText;

  DiceRollValue roll() {
    return DiceRollValue(
      base: max != null ? base.rollMax() : base.roll(),
      diceBonuses: max != null ? diceBonuses.rollMax() : diceBonuses.roll(),
      intBonuses: intBonuses,
    );
  }

  @override
  String toString() => "${base.base}$intBonusString$diceBonuses";
}

class DiceRollValue {
  final DiceRoll base;
  final Map<Bonus, DiceRoll> diceBonuses;
  final Bonuses<Int> intBonuses;

  const DiceRollValue({
    required this.base,
    required this.diceBonuses,
    required this.intBonuses,
  });

  DiceRollValue.from(this.base)
      : diceBonuses = {},
        intBonuses = Bonuses.empty();

  Bonuses<Int> get diceTotals => Bonuses.totals(diceBonuses);
  Bonuses<Int> get bonuses => intBonuses + diceTotals;

  int get total => base.total + bonuses.total.value;

  Value<Int> get intValue {
    return Value.from(
      Int(base.total),
      bonuses,
    );
  }

  void addBonusRoll(Bonus bonus, DiceRoll roll) {
    diceBonuses[bonus] = roll;
  }

  @override
  String toString() => "$total";
}

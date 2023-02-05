import 'package:dungeons/game/bonus.dart';
import 'package:dungeons/game/bonuses.dart';
import 'package:dungeons/utility/bonus_text.dart';
import 'package:dungeons/utility/dice.dart';
import 'package:dungeons/utility/percent.dart';
import 'package:dungeons/utility/range.dart';

class IntValue implements Comparable<IntValue> {
  final int base;
  final IntBonuses bonuses;

  const IntValue({
    this.base = 0,
    this.bonuses = const IntBonuses(),
  });

  int get bonus => bonuses.total;
  int get total => base + bonus;

  bool operator >(IntValue other) => total > other.total;

  @override
  String toString() => '$total';

  @override
  int compareTo(IntValue other) => total - other.total;
}

class PercentValue {
  final Percent base;
  final PercentBonuses bonuses;
  final MultiplierBonuses multipliers;

  const PercentValue({
    this.base = const Percent(),
    this.bonuses = const PercentBonuses(),
    this.multipliers = const MultiplierBonuses(),
  });

  Percent get bonus => bonuses.total;
  Percent get unscaled => base + bonus;
  Percent get multiplierBonus => unscaled.multiply(multipliers.total);
  Percent get total => unscaled + multiplierBonus;

  PercentValueRoll roll() {
    return PercentValueRoll(input: this, result: total.roll());
  }

  @override
  String toString() => '$total';
}

class PercentValueRoll {
  final PercentValue input;
  final PercentRoll result;

  const PercentValueRoll({required this.input, required this.result});

  bool get success => result.success;
  bool get fail => result.fail;
}

class DiceValue {
  final Dice base;
  final DiceBonuses diceBonuses;
  final IntBonuses intBonuses;
  final bool max;

  DiceValue({
    required this.base,
    DiceBonuses? diceBonuses,
    this.intBonuses = const IntBonuses(),
    this.max = false,
  }) : diceBonuses = diceBonuses ?? DiceBonuses();

  void addDice(Bonus bonus, Dice dice) {
    diceBonuses.add(bonus, dice);
  }

  Range get range => base.range + diceBonuses.range + intBonuses.total;

  int get intBonusTotal => base.bonus + intBonuses.total;
  String get intBonusString => bonusText(intBonusTotal);
  int get maxTotal => base.max + diceBonuses.maxTotal + intBonuses.total;

  DiceRollValue roll() {
    return DiceRollValue(
      input: this,
      base: max ? base.rollMax() : base.roll(),
      diceBonuses: max ? diceBonuses.rollMax() : diceBonuses.roll(),
    );
  }

  @override
  String toString() => '${base.base}$intBonusString$diceBonuses';
}

class DiceRollValue {
  final DiceValue input;
  final DiceRoll base;
  final DiceRollBonuses diceBonuses;

  const DiceRollValue({
    required this.input,
    required this.base,
    this.diceBonuses = const DiceRollBonuses(),
  });

  factory DiceRollValue.roll(Dice dice) {
    return DiceValue(base: dice).roll();
  }

  IntBonuses get intBonuses => input.intBonuses;
  bool get max => input.max;

  int get bonusTotal => intBonuses.total + diceBonuses.totals.total;
  int get total => base.total + bonusTotal;

  @override
  String toString() => '$total';
}

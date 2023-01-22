import 'package:dungeons/game/effect.dart';
import 'package:dungeons/game/effects.dart';
import 'package:dungeons/utility/bonus_text.dart';
import 'package:dungeons/utility/dice.dart';
import 'package:dungeons/utility/percent.dart';
import 'package:dungeons/utility/range.dart';

class IntValue implements Comparable<IntValue> {
  final int base;
  final IntEffects bonuses;

  IntValue({
    this.base = 0,
    IntEffects? bonuses,
  }) : bonuses = bonuses ?? IntEffects();

  int get bonus => bonuses.total;
  int get total => base + bonus;

  void addBonus(Effect effect, int b) {
    bonuses.add(effect, b);
  }

  bool operator >(IntValue other) => total > other.total;

  @override
  String toString() => '$total';

  @override
  int compareTo(IntValue other) => total - other.total;
}

class PercentValue {
  final Percent base;
  final PercentEffects bonuses;
  final PercentEffects scaling;

  const PercentValue({
    this.base = const Percent(),
    this.bonuses = const PercentEffects(),
    this.scaling = const PercentEffects(),
  });

  Percent get bonus => bonuses.total;
  Percent get unscaled => base + bonus;
  Percent get scaleBonus =>
      scaling.isEmpty ? const Percent() : scaling.total.of(unscaled);
  Percent get total => unscaled + scaleBonus;

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
  final DiceEffects diceBonuses;
  final IntEffects intBonuses;
  final bool max;

  DiceValue({
    required this.base,
    DiceEffects? diceBonuses,
    IntEffects? intBonuses,
    this.max = false,
  })  : diceBonuses = diceBonuses ?? DiceEffects(),
        intBonuses = intBonuses ?? IntEffects();

  void addDice(Effect effect, Dice dice) {
    diceBonuses.add(effect, dice);
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
  final DiceRollEffects diceBonuses;

  const DiceRollValue({
    required this.input,
    required this.base,
    this.diceBonuses = const DiceRollEffects(),
  });

  factory DiceRollValue.roll(Dice dice) {
    return DiceValue(base: dice).roll();
  }

  IntEffects get intBonuses => input.intBonuses;
  bool get max => input.max;

  int get bonusTotal => intBonuses.total + diceBonuses.totals.total;
  int get total => base.total + bonusTotal;

  @override
  String toString() => '$total';
}

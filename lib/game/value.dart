import 'package:dungeons/utility/bonus_text.dart';
import 'package:dungeons/utility/dice.dart';
import 'package:dungeons/utility/percent.dart';
import 'package:dungeons/utility/range.dart';

class IntValue implements Comparable<IntValue> {
  final int base;
  final int bonus;

  const IntValue({this.base = 0, this.bonus = 0});

  int get total => base + bonus;

  IntValue addBonus(int b) => IntValue(base: base, bonus: bonus + b);

  bool operator >(IntValue other) => total > other.total;

  @override
  String toString() => total.toString();

  @override
  int compareTo(IntValue other) => total - other.total;
}

class PercentValue {
  final Percent base;
  final Percent bonus;

  const PercentValue({
    this.base = const Percent(),
    this.bonus = const Percent(),
  });

  Percent get total => base + bonus;

  PercentRoll roll() => total.roll();

  @override
  String toString() => total.toString();
}

class DiceValue {
  final Dice dice;
  final IntValue bonus;

  const DiceValue({required this.dice, required this.bonus});

  Range get range => dice.range + bonus.total;

  DiceRollValue roll() => DiceRollValue(dice.roll(), bonus);

  @override
  String toString() => '$dice${bonusText(bonus.total)}';
}

class DiceRollValue {
  final DiceRoll dice;
  final IntValue bonus;

  const DiceRollValue(this.dice, this.bonus);

  int get total => dice.total + bonus.total;

  IntValue get value {
    return IntValue(
      base: dice.total + bonus.base,
      bonus: bonus.bonus,
    );
  }

  @override
  String toString() => total.toString();
}

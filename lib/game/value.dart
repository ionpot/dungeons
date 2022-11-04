import 'package:dungeons/utility/bonus_text.dart';
import 'package:dungeons/utility/dice.dart';
import 'package:dungeons/utility/percent.dart';
import 'package:dungeons/utility/range.dart';

class IntValue implements Comparable<IntValue> {
  final int base;
  final int bonus;

  const IntValue({required this.base, this.bonus = 0});
  const IntValue.base(int base) : this(base: base);

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

  const PercentValue({required this.base, required this.bonus});

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

  IntValue roll() {
    return IntValue(
      base: dice.roll() + bonus.base,
      bonus: bonus.bonus,
    );
  }

  @override
  String toString() => '$dice${bonusText(bonus.total)}';
}

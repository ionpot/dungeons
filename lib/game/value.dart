import 'package:dungeons/utility/bonus_text.dart';
import 'package:dungeons/utility/dice.dart';
import 'package:dungeons/utility/percent.dart';
import 'package:dungeons/utility/range.dart';

class IntValue {
  final int base;
  final int bonus;

  const IntValue({required this.base, required this.bonus});

  int get total => base + bonus;

  @override
  String toString() => total.toString();
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

  int roll() => dice.roll() + bonus.total;

  @override
  String toString() => '$dice${bonusText(bonus.total)}';
}

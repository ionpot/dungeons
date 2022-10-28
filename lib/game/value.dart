import 'package:dungeons/utility/dice.dart';
import 'package:dungeons/utility/percent.dart';

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
  final Dice base;
  final IntValue bonus;

  const DiceValue({required this.base, required this.bonus});

  Dice get dice => base.withBonus(bonus.total);

  int roll() => dice.roll();

  @override
  String toString() => '$dice';
}

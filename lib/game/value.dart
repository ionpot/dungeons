import 'package:dungeons/utility/percent.dart';

class IntValue {
  final int base;
  final int bonus;

  IntValue({required this.base, required this.bonus});

  int get total => base + bonus;

  @override
  String toString() => total.toString();
}

class PercentValue {
  final Percent base;
  final Percent bonus;

  PercentValue({required this.base, required this.bonus});

  Percent get total => base + bonus;

  @override
  String toString() => total.toString();
}

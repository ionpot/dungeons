import 'package:dungeons/utility/dice.dart';

class Percent implements Comparable<Percent> {
  final int value;

  const Percent([this.value = 0]);

  bool get always => value >= 100;
  bool get never => value <= 0;

  Percent invert() => Percent(100 - value);

  Percent of(Percent p) => Percent(ofInt(p.value));
  int ofInt(int i) => (value / 100 * i).floor();

  PercentRoll roll() {
    if (always) return PercentRoll(success: true);
    if (never) return PercentRoll(success: false);
    final result = const Dice.sides(100).roll();
    return PercentRoll(
      success: result <= value,
      result: result,
    );
  }

  Percent operator +(Percent other) => Percent(value + other.value);

  int get sign => value.sign;

  @override
  int compareTo(Percent other) => value - other.value;

  @override
  String toString() => '$value%';
}

class PercentRoll {
  final bool success;
  final int? result;

  PercentRoll({required this.success, this.result});

  bool get fail => !success;

  @override
  String toString() {
    if (result != null) {
      return '$result: ${success ? 'Success' : 'Fail'}';
    }
    return success ? 'Auto-success' : 'Auto-fail';
  }
}

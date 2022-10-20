import 'package:dungeons/utility/dice.dart';

class Percent implements Comparable<Percent> {
  final int value;

  const Percent([this.value = 0]);

  bool get always => value >= 100;
  bool get never => value <= 0;

  Percent invert() => Percent(100 - value);

  Percent of(Percent p) => Percent(ofInt(p.value));
  int ofInt(int i) => (value / 100 * i).floor();

  Percent operator +(Percent other) => Percent(value + other.value);

  @override
  int compareTo(Percent other) => value - other.value;

  @override
  String toString() => '$value%';
}

class PercentRoll {
  final Percent chance;
  bool success = false;
  int? result;

  PercentRoll(this.chance) {
    if (chance.always) {
      success = true;
    } else if (!chance.never) {
      result = const Dice.sides(100).roll();
      success = result! <= chance.value;
    }
  }

  bool get fail => !success;

  @override
  String toString() {
    final head = '($chance)';
    final tail = success ? 'success' : 'fail';
    if (result != null) {
      return '$head $result, $tail.';
    }
    return '$head Auto-$tail.';
  }
}

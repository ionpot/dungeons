import 'package:dungeons/utility/dice.dart';
import 'package:dungeons/utility/has_text.dart';
import 'package:dungeons/utility/scale.dart';

class Percent implements Comparable<Percent>, HasText {
  final int value;

  const Percent([this.value = 0]);

  bool get always => value >= 100;
  bool get never => value <= 0;

  Percent invert() => Percent(100 - value);

  Percent scaleBy(Scale? scale) => Percent(scale?.applyTo(value) ?? value);

  @override
  int compareTo(Percent other) => value - other.value;

  @override
  String get text => '$value%';
}

class PercentRoll implements HasText {
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
  String get text {
    final head = '(${chance.text})';
    final tail = success ? 'success' : 'fail';
    if (result != null) {
      return '$head $result, $tail.';
    }
    return '$head Auto-$tail.';
  }
}

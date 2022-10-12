import 'package:dungeons/utility/dice.dart';
import 'package:dungeons/utility/has_text.dart';
import 'package:dungeons/utility/scale.dart';

class Percent implements Comparable<Percent>, HasText {
  final int value;

  const Percent([this.value = 0]);

  PercentRoll roll() {
    if (value >= 100) return const PercentRoll(success: true);
    if (value <= 0) return const PercentRoll(success: false);
    const dice = Dice.sides(100);
    final result = dice.roll();
    return PercentRoll(
      result: result,
      success: result <= value,
    );
  }

  Percent scaleBy(Scale? scale) => Percent(scale?.applyTo(value) ?? value);

  @override
  int compareTo(Percent other) => value - other.value;

  @override
  String get text => '$value%';
}

class PercentRoll {
  final int? result;
  final bool success;

  const PercentRoll({
    this.result,
    required this.success,
  });

  bool get fail => !success;
}

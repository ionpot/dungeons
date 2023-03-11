import 'package:dungeons/utility/dice.dart';
import 'package:dungeons/utility/multiplier.dart';

class Percent implements Comparable<Percent> {
  final int value;

  const Percent([this.value = 0]);

  bool get always => value >= 100;
  bool get never => value <= 0;
  bool get maybe => !always && !never;
  bool get zero => value == 0;

  Percent invert() => Percent(100 - value);

  Percent multiply(Multiplier m) => Percent((value * m.value).floor());

  PercentRoll roll([int count = 1]) {
    return PercentRoll(
      chance: this,
      roll: Dice(count, 100).roll(),
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
  final Percent chance;
  final DiceRoll roll;

  const PercentRoll({required this.chance, required this.roll});

  PercentRoll forChance(Percent percent) {
    return PercentRoll(chance: percent, roll: roll);
  }

  bool get rollSuccess => roll.any((result) => result <= chance.value);
  bool get rollFail => !rollSuccess;

  bool get success => chance.always || rollSuccess;
  bool get fail => chance.never || rollFail;

  String text(bool critical) {
    if (chance.always) return 'Auto-success';
    if (chance.never) return 'Auto-fail';
    return '$roll -> ${success ? critical ? 'Critical!' : 'Success' : 'Fail'}';
  }

  @override
  String toString() => text(false);
}

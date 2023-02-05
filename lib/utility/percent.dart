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

  PercentRoll roll() {
    return PercentRoll(
      chance: this,
      roll: const Dice(1, 100).roll().total,
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
  final int roll;

  const PercentRoll({required this.chance, required this.roll});

  bool get success => chance.always || roll <= chance.value;
  bool get fail => chance.never || roll > chance.value;

  @override
  String toString() {
    if (chance.always) return 'Auto-success';
    if (chance.never) return 'Auto-fail';
    return '$roll: ${success ? 'Success' : 'Fail'}';
  }
}

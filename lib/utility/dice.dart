import 'dart:math';

import 'package:dungeons/utility/range.dart';

class Dice implements Comparable<Dice> {
  final int count;
  final int sides;

  const Dice(this.count, this.sides);
  const Dice.sides(int sides) : this(1, sides);

  int get min => count;
  int get max => count * sides;

  Range get range => Range(min, max);

  DiceRoll roll() {
    final random = Random();
    final rolls = List.generate(
      count,
      (_) => random.nextInt(sides) + 1,
      growable: false,
    );
    return DiceRoll(rolls);
  }

  DiceRoll rollMax() {
    final rolls = List.filled(count, sides);
    return DiceRoll(rolls);
  }

  @override
  int compareTo(Dice other) => max - other.max;

  @override
  String toString() => '${count}d$sides';
}

class DiceRoll {
  final List<int> rolls;

  const DiceRoll(this.rolls);

  int get total => rolls.fold(0, (previous, current) => previous + current);

  @override
  String toString() => rolls.join(" ");
}

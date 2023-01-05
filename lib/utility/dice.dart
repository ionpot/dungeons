import 'dart:math';

import 'package:dungeons/utility/bonus_text.dart';
import 'package:dungeons/utility/range.dart';

class Dice implements Comparable<Dice> {
  final int count;
  final int sides;
  final int bonus;

  const Dice(this.count, this.sides, {this.bonus = 0});

  int get min => count + bonus;
  int get max => count * sides + bonus;

  Range get range => Range(min, max);

  DiceRoll roll() {
    final random = Random();
    final rolls = List.generate(
      count,
      (_) => random.nextInt(sides) + 1,
      growable: false,
    );
    return DiceRoll(rolls, bonus);
  }

  DiceRoll rollMax() {
    final rolls = List.filled(count, sides);
    return DiceRoll(rolls, bonus);
  }

  @override
  int compareTo(Dice other) => max - other.max;

  @override
  String toString() => '${count}d$sides${bonusText(bonus)}';
}

class DiceRoll {
  final List<int> rolls;
  final int bonus;

  const DiceRoll(this.rolls, this.bonus);

  int get total => rolls.fold(bonus, (previous, current) => previous + current);

  @override
  String toString() => rolls.join(" ");
}

import 'dart:math';

import 'package:dungeons/utility/bonus_text.dart';
import 'package:dungeons/utility/range.dart';

class Dice implements Comparable<Dice> {
  final int count;
  final int sides;
  final int bonus;

  const Dice(this.count, this.sides, {this.bonus = 0});

  Dice get base => Dice(count, sides);

  int get min => count + bonus;
  int get max => count * sides + bonus;

  Range get range => Range(min, max);

  Dice addBonus(int value) => Dice(count, sides, bonus: bonus + value);

  DiceRoll roll() {
    final random = Random();
    final rolls = List.generate(
      count,
      (_) => random.nextInt(sides) + 1,
      growable: false,
    );
    return DiceRoll(this, rolls);
  }

  DiceRoll rollMax() {
    final rolls = List.filled(count, sides);
    return DiceRoll(this, rolls);
  }

  String get sideText => 'd$sides';

  @override
  int compareTo(Dice other) => max - other.max;

  @override
  String toString() => '$count$sideText${bonusText(bonus)}';

  static int maxTotal(Iterable<Dice> list) {
    return list.fold(0, (sum, dice) => sum + dice.max);
  }

  static Range totalRange(Iterable<Dice> list) {
    return list.fold(const Range(0, 0), (range, dice) => range + dice.range);
  }
}

class DiceRoll {
  final Dice dice;
  final List<int> rolls;

  const DiceRoll(this.dice, this.rolls);

  int get total => rolls.fold(dice.bonus, (sum, roll) => sum + roll);

  @override
  String toString() => rolls.join(" ");
}

import 'dart:math';

import 'package:dungeons/utility/bonus_text.dart';
import 'package:dungeons/utility/has_text.dart';
import 'package:dungeons/utility/range.dart';

class Dice implements Comparable<Dice>, HasText {
  final int count;
  final int sides;
  final int bonus;

  const Dice(this.count, this.sides, {this.bonus = 0});
  const Dice.sides(int sides) : this(1, sides);

  Dice withBonus(int bonus) => Dice(count, sides, bonus: bonus);

  int get min => count + bonus;
  int get max => count * sides + bonus;
  Range get range => Range(min, max);

  int roll() {
    final random = Random();
    int result = 0;
    for (int i = 0; i < count; ++i) {
      result += random.nextInt(sides);
    }
    return result + bonus;
  }

  @override
  int compareTo(Dice other) => max - other.max;

  @override
  String get text => '${count}d$sides${bonusText(bonus)}';

  String get fullText => '($text) ${range.text}';
}

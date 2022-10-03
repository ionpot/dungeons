import 'dart:math';

import 'package:dungeons/utility/has_text.dart';

class Dice implements Comparable<Dice>, HasText {
  final int count;
  final int sides;

  const Dice(this.count, this.sides);
  const Dice.sides(int sides) : this(1, sides);

  int get min => count;
  int get max => count * sides;

  int roll() {
    final random = Random();
    int result = 0;
    for (int i = 0; i < count; ++i) {
      result += random.nextInt(sides);
    }
    return result;
  }

  @override
  int compareTo(Dice other) => max - other.max;

  @override
  String get text => '${count}d$sides';
}

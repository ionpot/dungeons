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

  int roll() {
    final random = Random();
    int result = 0;
    for (int i = 0; i < count; ++i) {
      result += random.nextInt(sides) + 1;
    }
    return result;
  }

  @override
  int compareTo(Dice other) => max - other.max;

  @override
  String toString() => '${count}d$sides';
}

import 'dart:math';

class Range {
  final int min;
  final int max;

  const Range(this.min, this.max);

  int roll() => Random().nextInt(max + 1 - min) + min;

  Range sanitize() => Range(min, max < min ? min : max);

  Range withMin(int x) => Range(min < x ? x : min, max).sanitize();

  Range operator +(int i) => Range(min + i, max + i);

  @override
  String toString() => (min == max) ? '$min' : '$min - $max';
}

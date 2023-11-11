import "dart:math";

class Range {
  final int min;
  final int max;

  const Range(this.min, this.max);

  int roll() => Random().nextInt(max + 1 - min) + min;

  Range sanitize() => Range(min, max < min ? min : max);

  Range withMin(int x) => Range(min < x ? x : min, max).sanitize();

  Range operator +(dynamic other) {
    if (other is int) {
      return Range(min + other, max + other);
    }
    if (other is Range) {
      return Range(min + other.min, max + other.max);
    }
    throw ArgumentError.value(other, "other");
  }

  @override
  String toString() => (min == max) ? "$min" : "$min - $max";
}

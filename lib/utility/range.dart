import "dart:math";

class Range {
  final int min;
  final int max;

  const Range(this.min, this.max);

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

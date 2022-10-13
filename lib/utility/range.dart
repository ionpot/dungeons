class Range {
  final int min;
  final int max;

  const Range(this.min, this.max);

  Range operator +(int i) => Range(min + i, max + i);

  @override
  String toString() => (min == max) ? '$min' : '$min - $max';
}

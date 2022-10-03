import 'package:dungeons/utility/has_text.dart';

class Range implements HasText {
  final int min;
  final int max;

  const Range(this.min, this.max);

  Range operator +(int i) => Range(min + i, max + i);

  @override
  String get text => (min == max) ? '$min' : '$min - $max';
}

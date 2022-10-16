import 'package:dungeons/utility/range.dart';

class Deviate {
  final int min;
  final int max;

  const Deviate(this.min, this.max);

  Range from(int x) => Range(x - min, x + max);
}

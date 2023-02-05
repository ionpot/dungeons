import 'package:dungeons/utility/fixed_string.dart';

class Multiplier {
  final double value;

  const Multiplier(this.value);

  bool get zero => value == 0;

  Multiplier operator +(Multiplier other) {
    return Multiplier(value + other.value);
  }

  @override
  String toString() {
    final sign = value < 0 ? '- ' : '';
    return '${sign}x${toFixedString(value.abs())}';
  }
}

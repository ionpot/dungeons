class Scale implements Comparable<Scale> {
  final double value;

  const Scale([this.value = 1]);

  int applyTo(int x) {
    if (value == 1) return x;
    double scaled = x * value;
    return (value < 1) ? scaled.ceil() : scaled.floor();
  }

  @override
  int compareTo(Scale other) => (value - other.value).sign.toInt();
}

String toFixedString(double value) => _trimZeroes(value.toStringAsFixed(2));

String toFixedBonusString(double value) {
  if (value == 0) {
    return "";
  }
  final str = toFixedString(value);
  return value > 0 ? "+$str" : str;
}

String _trimZeroes(String input) {
  final sub = input.substring(0, input.length - 1);
  if (input.endsWith("0")) {
    return _trimZeroes(sub);
  }
  if (input.endsWith(".")) {
    return sub;
  }
  return input;
}

class IntValue {
  final int base;
  final int bonus;

  IntValue({required this.base, required this.bonus});

  int get total => base + bonus;

  @override
  String toString() => total.toString();
}

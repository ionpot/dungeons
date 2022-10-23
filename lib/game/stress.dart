class Stress {
  final int current;
  final int reserved;
  final int cap;

  const Stress({this.current = 0, this.reserved = 0, required this.cap});

  int get currentCap => cap - reserved;

  bool has(int i) => (current + i) <= currentCap;
}

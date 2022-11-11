import 'package:dungeons/game/value.dart';

class Stress {
  final int current;
  final int reserved;
  final IntValue cap;

  const Stress({this.current = 0, this.reserved = 0, required this.cap});

  int get currentCap => cap.total - reserved;

  bool has(int i) => (current + i) <= currentCap;
}

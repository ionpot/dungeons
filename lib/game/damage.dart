import 'package:dungeons/game/value.dart';

enum DamageType { normal }

class Damage {
  final DamageType type = DamageType.normal;
  final IntValue value;

  const Damage(this.value);

  int get total => value.total;

  @override
  String toString() => '$total';
}

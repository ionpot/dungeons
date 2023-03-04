import 'package:dungeons/game/value.dart';
import 'package:dungeons/game/weapon.dart';
import 'package:dungeons/utility/dice.dart';

class CriticalHit {
  final PercentValue chance;
  final Weapon weapon;

  const CriticalHit({required this.chance, required this.weapon});

  Dice get dice => weapon.dice.base;

  @override
  String toString() => 'Critical hit';
}

import 'package:dungeons/game/value.dart';
import 'package:dungeons/utility/dice.dart';

class CriticalHit {
  final PercentValue chance;
  final Dice dice;

  const CriticalHit({required this.chance, required this.dice});

  @override
  String toString() => 'Critical hit';
}

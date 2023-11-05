import 'package:dungeons/game/value.dart';
import 'package:dungeons/utility/dice.dart';

class CriticalHit {
  final PercentValue chance;
  final Dice dice;

  const CriticalHit({required this.chance, required this.dice});

  @override
  int get hashCode => Object.hash(chance, dice);

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  String toString() => 'Critical hit';
}

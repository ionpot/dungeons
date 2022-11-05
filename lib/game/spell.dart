import 'package:dungeons/game/damage.dart';
import 'package:dungeons/utility/dice.dart';

enum Spell {
  magicMissile(
    text: 'Magic Missile',
    stress: 1,
    autoHit: true,
    damage: DamageDice(Dice(3, 4), type: DamageType.astral),
  );

  final String text;
  final int stress;
  final bool autoHit;
  final DamageDice? damage;

  const Spell({
    required this.text,
    required this.stress,
    this.autoHit = false,
    this.damage,
  });
}

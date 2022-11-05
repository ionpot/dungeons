import 'package:dungeons/game/damage.dart';
import 'package:dungeons/game/effect_bonus.dart';
import 'package:dungeons/utility/dice.dart';

enum Spell {
  magicMissile(
    text: 'Magic Missile',
    stress: 1,
    autoHit: true,
    damage: DamageDice(Dice(3, 4), type: DamageType.astral),
  ),
  rayOfFrost(
    text: 'Ray of Frost',
    stress: 1,
    damage: DamageDice(Dice(2, 8), type: DamageType.cold),
    effect: EffectBonus(initiative: -2),
  );

  final String text;
  final int stress;
  final bool autoHit;
  final DamageDice? damage;
  final EffectBonus? effect;

  const Spell({
    required this.text,
    required this.stress,
    this.autoHit = false,
    this.damage,
    this.effect,
  });
}

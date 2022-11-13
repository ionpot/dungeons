import 'package:dungeons/game/effect_bonus.dart';
import 'package:dungeons/game/source.dart';
import 'package:dungeons/game/value.dart';
import 'package:dungeons/utility/dice.dart';
import 'package:dungeons/utility/percent.dart';

enum Spell {
  bless(
    text: 'Bless',
    source: Source.radiant,
    reserveStress: 2,
    selfCast: true,
    effect: EffectBonus(
      stressCap: 1,
      hitChance: Percent(1),
      resistChance: Percent(1),
    ),
  ),
  heal(
    text: 'Heal',
    source: Source.radiant,
    stress: 1,
    heals: DiceValue(base: Dice(1, 6), bonus: IntValue(base: 2)),
    selfCast: true,
  ),
  magicMissile(
    text: 'Magic Missile',
    source: Source.astral,
    stress: 1,
    autoHit: true,
    damage: Dice(3, 4),
  ),
  rayOfFrost(
    text: 'Ray of Frost',
    source: Source.cold,
    stress: 1,
    damage: Dice(2, 8),
    effect: EffectBonus(initiative: -2),
    stacks: true,
  );

  final String text;
  final Source source;
  final int stress;
  final int reserveStress;
  final bool autoHit;
  final bool selfCast;
  final bool stacks;
  final Dice? damage;
  final DiceValue? heals;
  final EffectBonus? effect;

  const Spell({
    required this.text,
    required this.source,
    this.stress = 0,
    this.reserveStress = 0,
    this.autoHit = false,
    this.selfCast = false,
    this.stacks = false,
    this.damage,
    this.heals,
    this.effect,
  });

  @override
  String toString() => text;
}

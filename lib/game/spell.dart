import "package:dungeons/game/effect.dart";
import "package:dungeons/game/grid_range.dart";
import "package:dungeons/game/source.dart";
import "package:dungeons/utility/dice.dart";
import "package:dungeons/utility/percent.dart";

enum Spell {
  bless(
    text: "Bless",
    source: Source.radiant,
    stress: 2,
    reserveStress: true,
    range: GridRange.ally,
    effect: Effect(
      maxWeaponDamage: true,
      resistChance: Percent(4),
    ),
  ),
  heal(
    text: "Heal",
    source: Source.radiant,
    stress: 2,
    range: GridRange.ally,
    heals: Dice(1, 6, bonus: 4),
  ),
  lightningBolt(
    text: "Lightning Bolt",
    source: Source.lightning,
    stress: 3,
    range: GridRange.any,
    damage: Dice(3, 10),
    requiresLevel: 5,
  ),
  magicMissile(
    text: "Magic Missile",
    source: Source.astral,
    stress: 2,
    range: GridRange.any,
    autoHit: true,
    damage: Dice(3, 4),
  ),
  rayOfFrost(
    text: "Ray of Frost",
    source: Source.cold,
    stress: 2,
    range: GridRange.any,
    damage: Dice(2, 8),
    effect: Effect(initiative: -2),
    stacks: true,
  );

  final String text;
  final Source source;
  final int stress;
  final bool reserveStress;
  final int requiresLevel;
  final bool autoHit;
  final bool stacks;
  final Dice? damage;
  final Dice? heals;
  final Effect? effect;
  final GridRange? range;

  const Spell({
    required this.text,
    required this.source,
    this.stress = 0,
    this.reserveStress = false,
    this.requiresLevel = 1,
    this.autoHit = false,
    this.stacks = false,
    this.damage,
    this.heals,
    this.effect,
    this.range,
  });

  @override
  String toString() => text;
}

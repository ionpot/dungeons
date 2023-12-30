import "package:dungeons/game/bonus_value.dart";
import "package:dungeons/utility/monoids.dart";

enum StatusEffect {
  bless(
    text: "Bless",
    bonuses: [PercentBonus.resist(Percent(4))],
    effects: [StatusEffect.maxDamage],
  ),
  maxDamage(text: "Max damage"),
  noStress(text: "No stress"),
  slow(text: "Slow", bonuses: [IntBonus.initiative(-2)]);

  final String text;
  final List<BonusValue> bonuses;
  final List<StatusEffect> effects;

  const StatusEffect({
    required this.text,
    this.bonuses = const [],
    this.effects = const [],
  });
}

import "package:dungeons/game/bonus_value.dart";
import "package:dungeons/game/status_effect.dart";

enum EntityRace {
  human("Human"),
  orc(
    "Orc",
    bonuses: [
      IntBonus.strength(2),
      IntBonus.intellect(-2),
    ],
    effects: [StatusEffect.canFrenzy, StatusEffect.noStress],
  );

  final String text;
  final List<BonusValue> bonuses;
  final List<StatusEffect> effects;

  const EntityRace(
    this.text, {
    this.bonuses = const [],
    this.effects = const [],
  });

  @override
  String toString() => text;
}

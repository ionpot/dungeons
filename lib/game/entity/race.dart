import "package:dungeons/game/entity/status_effect.dart";

enum EntityRace {
  human("Human"),
  orc(
    "Orc",
    effects: [StatusEffect.canFrenzy, StatusEffect.noStress],
  );

  final String text;
  final List<StatusEffect> effects;

  const EntityRace(
    this.text, {
    this.effects = const [],
  });

  @override
  String toString() => text;
}

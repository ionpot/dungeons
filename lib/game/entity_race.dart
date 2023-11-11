import "package:dungeons/game/effect.dart";

enum EntityRace {
  human("Human"),
  orc("Orc", Effect(strength: 2, intellect: -2));

  final String text;
  final Effect? effect;

  const EntityRace(this.text, [this.effect]);

  @override
  String toString() => text;
}

import "package:dungeons/game/bonus_value.dart";

enum EntityRace {
  human("Human"),
  orc("Orc", bonuses: [
    IntBonus.strength(2),
    IntBonus.intellect(-2),
  ]);

  final String text;
  final List<BonusValue> bonuses;

  const EntityRace(this.text, {this.bonuses = const []});

  @override
  String toString() => text;
}

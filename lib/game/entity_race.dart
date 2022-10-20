enum EntityRace {
  human('Human'),
  orc('Orc', strength: 2, intellect: -2);

  final int strength;
  final int intellect;
  final String text;

  const EntityRace(
    this.text, {
    this.strength = 0,
    this.intellect = 0,
  });

  @override
  String toString() => text;
}

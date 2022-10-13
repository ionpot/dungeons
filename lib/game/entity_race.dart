import 'package:dungeons/game/entity_attr.dart';

class EntityRace {
  final EntityAttributes bonus;
  final String text;

  const EntityRace(this.text, this.bonus);

  @override
  String toString() => text;
}

final human = EntityRace('Human', EntityAttributes());
final orc = EntityRace('Orc', EntityAttributes(strength: 2, intellect: -2));

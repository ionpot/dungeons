import 'package:dungeons/game/entity_attr.dart';

class EntityRace {
  final EntityAttributes bonus;

  const EntityRace(this.bonus);
}

final human = EntityRace(EntityAttributes());
final orc = EntityRace(EntityAttributes(strength: 2, intellect: -2));

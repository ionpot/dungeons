import 'package:dungeons/game/entity_attr.dart';
import 'package:dungeons/game/entity_class.dart';

class Entity {
  final String name;
  EntityAttributes attributes = EntityAttributes();
  EntityClass? klass;

  Entity(this.name);

  int totalHp() => attributes.strength + (klass?.hpBonus ?? 0);
}

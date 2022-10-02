import 'package:dungeons/game/entity_armor.dart';
import 'package:dungeons/game/entity_attr.dart';
import 'package:dungeons/game/entity_class.dart';

class Entity {
  final String name;
  EntityAttributes attributes = EntityAttributes();
  EntityClass? klass;
  EntityArmor? armor;

  Entity(this.name);

  int get initiative => attributes.initiative + (armor?.initiative ?? 0);

  int totalArmor() => armor?.value ?? 0;
  int totalHp() => attributes.strength + (klass?.hpBonus ?? 0);
}

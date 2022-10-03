import 'package:dungeons/game/entity_armor.dart';
import 'package:dungeons/game/entity_attr.dart';
import 'package:dungeons/game/entity_class.dart';
import 'package:dungeons/game/entity_race.dart';
import 'package:dungeons/utility/percent.dart';

class Entity {
  final String name;
  EntityAttributes base = EntityAttributes();
  EntityRace? race;
  EntityClass? klass;
  EntityArmor? armor;

  Entity(this.name, {this.race});

  EntityAttributes get attributes => base + race?.bonus;

  int get initiative => attributes.initiative + (armor?.initiative ?? 0);

  Percent get dodge => attributes.dodge.scaleBy(armor?.dodge);
  Percent get resist => attributes.resist;

  int totalArmor() => armor?.value ?? 0;
  int totalHp() => attributes.strength + (klass?.hpBonus ?? 0);
}

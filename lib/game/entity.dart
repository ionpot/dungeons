import 'package:dungeons/game/armor.dart';
import 'package:dungeons/game/entity_attr.dart';
import 'package:dungeons/game/entity_class.dart';
import 'package:dungeons/game/entity_race.dart';
import 'package:dungeons/game/weapon.dart';
import 'package:dungeons/utility/dice.dart';
import 'package:dungeons/utility/intcmp.dart';
import 'package:dungeons/utility/percent.dart';

class Entity {
  final String name;
  EntityAttributes base = EntityAttributes();
  EntityRace race;
  EntityClass? klass;
  Armor? armor;
  Weapon? weapon;

  Entity(this.name, {required this.race});

  EntityAttributes get attributes => base + race.bonus;

  int get initiative =>
      attributes.initiative +
      (armor?.initiative ?? 0) +
      (weapon?.initiative ?? 0);

  Percent get dodge => attributes.dodge.scaleBy(armor?.dodge);
  Percent get resist => attributes.resist;

  int get damageBonus => attributes.strength ~/ 2;
  Dice? get damageDice => weapon?.dice.withBonus(damageBonus);

  int get totalArmor => armor?.value ?? 0;
  int get totalHp => attributes.strength + (klass?.hpBonus ?? 0);

  bool get ok => (klass != null) && (armor != null) && (weapon != null);

  void randomize() {
    base.roll();
    klass = EntityClass.random();
    armor = Armor.random();
    weapon = Weapon.random();
  }

  int compareSpeed(Entity e) {
    final i = intcmp(initiative, e.initiative);
    if (i != 0) return i;
    final a = intcmp(e.totalArmor, totalArmor);
    if (a != 0) return a;
    return 0;
  }
}

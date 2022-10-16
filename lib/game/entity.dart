import 'package:dungeons/game/armor.dart';
import 'package:dungeons/game/entity_attr.dart';
import 'package:dungeons/game/entity_class.dart';
import 'package:dungeons/game/entity_race.dart';
import 'package:dungeons/game/weapon.dart';
import 'package:dungeons/utility/dice.dart';
import 'package:dungeons/utility/intcmp.dart';
import 'package:dungeons/utility/percent.dart';

class Entity {
  static int xpForLevelUp = 3;

  final String name;
  final bool player;
  EntityAttributes base = EntityAttributes();
  EntityRace race;
  int level = 1;
  int xp = 0;
  EntityClass? klass;
  Armor? armor;
  Weapon? weapon;
  int _damage = 0;

  Entity(this.name, {required this.race, this.player = false});

  EntityAttributes get attributes => base + race.bonus;

  int get initiative =>
      attributes.initiative +
      (armor?.initiative ?? 0) +
      (weapon?.initiative ?? 0);

  Percent get dodge => attributes.dodge.scaleBy(armor?.dodge);
  Percent get resist => attributes.resist;

  int get damageBonus => attributes.strength ~/ 2;
  Dice? get damageDice => weapon?.dice.withBonus(damageBonus);

  int get hitBonus => attributes.agility ~/ 4;

  int get totalArmor => armor?.value ?? 0;
  int get totalHp => attributes.strength + level * (klass?.hpBonus ?? 0);
  int get hp => totalHp - _damage;

  bool get ok => (klass != null) && (armor != null) && (weapon != null);

  bool get alive => hp > 0;
  bool get dead => !alive;

  bool canLevelUp() => canLevelUpWith(0);
  bool canLevelUpWith(int x) => (xp + x) >= xpForLevelUp;

  void levelUp() {
    xp -= xpForLevelUp;
    ++level;
  }

  void tryLevelUp() {
    if (canLevelUp()) levelUp();
  }

  void randomize() {
    base.roll();
    klass = EntityClass.random();
    armor = Armor.random();
    weapon = Weapon.random();
  }

  void resetHp() {
    _damage = 0;
  }

  void takeDamage(int value) {
    _damage += value;
  }

  Percent toHit(Entity e) => Percent(e.totalArmor - hitBonus).invert();

  int xpGain(Entity e) {
    if (level <= e.level) return 3;
    if (level - 1 == e.level) return 2;
    return 1;
  }

  int compareSpeed(Entity e) {
    final i = intcmp(initiative, e.initiative);
    if (i != 0) return i;
    final a = intcmp(e.totalArmor, totalArmor);
    if (a != 0) return a;
    return 0;
  }
}

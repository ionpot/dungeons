import 'package:dungeons/game/armor.dart';
import 'package:dungeons/game/effects.dart';
import 'package:dungeons/game/entity_attr.dart';
import 'package:dungeons/game/entity_class.dart';
import 'package:dungeons/game/entity_race.dart';
import 'package:dungeons/game/skill.dart';
import 'package:dungeons/game/stress.dart';
import 'package:dungeons/game/value.dart';
import 'package:dungeons/game/weapon.dart';
import 'package:dungeons/utility/deviate.dart';
import 'package:dungeons/utility/intcmp.dart';
import 'package:dungeons/utility/percent.dart';

class Entity {
  static int xpForLevelUp = 3;

  final String name;
  final bool player;
  final base = EntityAttributes();
  final EntityRace race;
  final effects = Effects();
  int level = 1;
  int xp = 0;
  int extraPoints = 0;
  EntityClass? klass;

  Armor? _armor;
  Weapon? _weapon;
  int _damage = 0;
  final int _stress = 0;

  Entity(this.name, {required this.race, this.player = false});

  int get strength => base.strength + race.strength;
  int get agility => base.agility;
  int get intellect => base.intellect + race.intellect;

  EntityAttributes get attributes => EntityAttributes(
        strength: strength,
        agility: agility,
        intellect: intellect,
      );

  IntValue get initiative => IntValue(
        base: (agility + intellect) ~/ 2,
        bonus: effects.sumInt((e) => e.initiative),
      );

  PercentValue get dodge {
    final base = Percent(agility);
    final scale = effects.sumPercent((e) => e.dodgeScale);
    return PercentValue(base: base, bonus: scale.of(base));
  }

  Percent get resist => Percent(intellect);

  IntValue get damageBonus {
    return IntValue(
      base: strength ~/ 2,
      bonus: effects.sumInt((e) => e.damage),
    );
  }

  DiceValue? get damage {
    if (_weapon == null) return null;
    return DiceValue(dice: _weapon!.dice, bonus: damageBonus);
  }

  int get hitBonus => agility ~/ 4;

  PercentValue hitChance(Entity target) {
    return PercentValue(
      base: Percent(target.totalArmor - hitBonus).invert(),
      bonus: effects.sumPercent((e) => e.hitChance),
    );
  }

  int get totalArmor => _armor?.value ?? 0;
  int get totalHp => strength + level * (klass?.hpBonus ?? 0);
  int get hp => totalHp - _damage;

  Stress get stress {
    return Stress(
      current: _stress,
      reserved: effects.reservedStress,
      cap: intellect + level,
    );
  }

  bool get ok => (klass != null) && (_armor != null) && (_weapon != null);

  bool get alive => hp > 0;
  bool get dead => !alive;

  Weapon? get weapon => _weapon;
  Armor? get armor => _armor;

  set weapon(Weapon? w) {
    effects.remove(Effect(weapon: _weapon));
    _weapon = w;
    if (w != null) {
      effects.add(Effect(weapon: w));
    }
  }

  set armor(Armor? a) {
    effects.remove(Effect(armor: _armor));
    _armor = a;
    if (a != null) {
      effects.add(Effect(armor: a));
    }
  }

  bool fasterThan(Entity e) {
    final i = intcmp(initiative.total, e.initiative.total);
    if (i != 0) return i == 1;
    final a = intcmp(totalArmor, e.totalArmor);
    if (a != 0) return a == -1;
    return player;
  }

  void activateSkill() {
    if (klass == EntityClass.warrior) {
      effects.add(const Effect(skill: Skill.weaponFocus));
    }
  }

  bool canUseSkill(Skill skill) {
    final cost = skill.reserveStress;
    return cost != null ? stress.has(cost) : true;
  }

  bool knowsSkill(Skill skill) {
    switch (skill) {
      case Skill.weaponFocus:
        return klass == EntityClass.warrior;
    }
  }

  SkillState skillState(Skill skill) {
    if (effects.has(Effect(skill: skill))) {
      return SkillState.active;
    }
    if (knowsSkill(skill)) {
      return canUseSkill(skill) ? SkillState.ready : SkillState.disabled;
    }
    return SkillState.unknown;
  }

  bool canLevelUp() => canLevelUpWith(0);
  bool canLevelUpWith(int x) => (xp + x) >= xpForLevelUp;

  void levelUp() {
    xp -= xpForLevelUp;
    ++level;
    extraPoints += 2;
  }

  void levelUpTo(int max) {
    while (level < max) {
      levelUp();
    }
  }

  void tryLevelUp() {
    if (canLevelUp()) levelUp();
  }

  void randomize() {
    base.roll();
    klass = EntityClass.random();
    armor = Armor.random();
    weapon = Weapon.random();
    spendAllPoints();
  }

  Entity rollEnemy() {
    return Entity('Enemy', race: EntityRace.orc)
      ..levelUpTo(rollEnemyLevel())
      ..randomize();
  }

  int rollEnemyLevel() => const Deviate(2, 0).from(level).withMin(1).roll();

  void resetHp() {
    _damage = 0;
  }

  void spendPointTo(EntityAttributeId id) {
    base.add(id);
    --extraPoints;
  }

  void spendAllPoints() {
    while (extraPoints > 0) {
      spendPointTo(EntityAttributeId.random());
    }
  }

  void takeDamage(int value) {
    _damage += value;
  }

  int xpGain(Entity e) {
    if (level <= e.level) return 3;
    if (level - 1 == e.level) return 2;
    return 1;
  }

  String toXpString() => '$xp/${Entity.xpForLevelUp}';
}

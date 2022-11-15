import 'package:dungeons/game/armor.dart';
import 'package:dungeons/game/effects.dart';
import 'package:dungeons/game/entity_attr.dart';
import 'package:dungeons/game/entity_class.dart';
import 'package:dungeons/game/entity_race.dart';
import 'package:dungeons/game/skill.dart';
import 'package:dungeons/game/spell.dart';
import 'package:dungeons/game/stress.dart';
import 'package:dungeons/game/value.dart';
import 'package:dungeons/game/weapon.dart';
import 'package:dungeons/utility/deviate.dart';
import 'package:dungeons/utility/dice.dart';
import 'package:dungeons/utility/if.dart';
import 'package:dungeons/utility/percent.dart';

class Entity {
  static int xpForLevelUp = 3;

  final String name;
  final bool player;
  final EntityAttributes base;
  final EntityRace race;
  final EntityClass klass;
  final effects = Effects();
  int level = 1;
  int xp = 0;
  int extraPoints = 0;

  Armor? _armor;
  Weapon? _weapon;
  int _damage = 0;
  int _stress = 0;

  Entity(
    this.name, {
    required this.base,
    required this.race,
    required this.klass,
    this.player = false,
  });

  int get strength => base.strength + race.strength;
  int get agility => base.agility;
  int get intellect => base.intellect + race.intellect;

  EntityAttributes get attributes {
    return EntityAttributes(
      strength: strength,
      agility: agility,
      intellect: intellect,
    );
  }

  IntValue get initiative {
    return IntValue(
      base: (agility + intellect) ~/ 2,
      bonus: effects.sumInt((e) => e.initiative),
    );
  }

  PercentValue get dodge {
    final base = Percent(agility);
    final scale = effects.sumPercent((e) => e.dodgeScale);
    return PercentValue(base: base, bonus: scale.of(base));
  }

  PercentValue get resist {
    return PercentValue(
      base: Percent(intellect),
      bonus: effects.sumPercent((e) => e.resistChance),
    );
  }

  IntValue get damageBonus {
    return IntValue(
      base: strength ~/ 2,
      bonus: effects.sumInt((e) => e.damage),
    );
  }

  DiceValue? get damage {
    if (_weapon == null) return null;
    return DiceValue(base: _weapon!.dice, bonus: damageBonus);
  }

  Dice? sneakDamage(Entity target) {
    return canSneakAttack(target) ? Skill.sneakAttack.dice : null;
  }

  int get hitBonus => agility ~/ 4;

  PercentValue hitChance(Entity target) {
    return PercentValue(
      base: Percent(target.totalArmor - hitBonus).invert(),
      bonus: effects.sumPercent((e) => e.hitChance),
    );
  }

  int get totalArmor => _armor?.value ?? 0;
  int get totalHp => strength + level * (klass.hpBonus);
  int get hp => totalHp - _damage;

  bool get injured => _damage > 0;

  Stress get stress {
    return Stress(
      current: _stress,
      reserved: effects.reservedStress,
      cap: IntValue(
        base: intellect + level,
        bonus: effects.sumInt((e) => e.stressCap),
      ),
    );
  }

  void addStress(int stress) {
    _stress += stress;
  }

  void clearStress() {
    _stress = 0;
  }

  bool get alive => hp > 0;
  bool get dead => !alive;

  Weapon? get weapon => _weapon;
  Armor? get armor => _armor;

  List<Spell> get knownSpells {
    switch (klass) {
      case EntityClass.cleric:
        return [Spell.bless, Spell.heal];
      case EntityClass.mage:
        return [Spell.magicMissile, Spell.rayOfFrost];
      case EntityClass.warrior:
      case EntityClass.trickster:
        return [];
    }
  }

  set weapon(Weapon? w) {
    ifdef(_weapon, effects.removeWeapon);
    _weapon = w;
    ifdef(w, effects.addWeapon);
  }

  set armor(Armor? a) {
    ifdef(_armor, effects.removeArmor);
    _armor = a;
    ifdef(a, effects.addArmor);
  }

  bool fasterThan(Entity other) {
    final i = initiative.compareTo(other.initiative);
    if (i != 0) return i > 0;
    final a = totalArmor.compareTo(other.totalArmor);
    if (a != 0) return a < 0;
    return player;
  }

  bool canSneakAttack(Entity target) {
    return klass == EntityClass.trickster && initiative > target.initiative;
  }

  void activateSkill() {
    if (klass == EntityClass.warrior) {
      effects.addSkill(Skill.weaponFocus);
    }
  }

  bool canSpellEffect(Spell spell) {
    if (spell.effect == null) return false;
    if (spell.stacks) return true;
    return !effects.hasSpell(spell);
  }

  bool canCast(Spell spell) {
    return stress.has(spell.stress);
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

  Entity rollEnemy() {
    return Entity(
      'Enemy',
      base: EntityAttributes.random(),
      race: EntityRace.orc,
      klass: EntityClass.random(),
    )
      ..levelUpTo(rollEnemyLevel())
      ..spendAllPoints()
      ..weapon = Weapon.random()
      ..armor = Armor.random();
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

  void heal(int value) {
    _damage -= _damage > value ? value : _damage;
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

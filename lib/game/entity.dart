import 'package:dungeons/game/armor.dart';
import 'package:dungeons/game/effects.dart';
import 'package:dungeons/game/entity_attr.dart';
import 'package:dungeons/game/entity_class.dart';
import 'package:dungeons/game/entity_race.dart';
import 'package:dungeons/game/skill.dart';
import 'package:dungeons/game/spell.dart';
import 'package:dungeons/game/value.dart';
import 'package:dungeons/game/weapon.dart';
import 'package:dungeons/utility/deviate.dart';
import 'package:dungeons/utility/dice.dart';
import 'package:dungeons/utility/if.dart';
import 'package:dungeons/utility/percent.dart';

class Entity extends _Base
    with
        _Effects,
        _Attributes,
        _Levels,
        _Health,
        _Stress,
        _Weapon,
        _Armor,
        _Spells {
  Entity(
    super.name, {
    required super.race,
    required super.klass,
    super.player = false,
  });

  PercentValue hitChance(Entity target) {
    final bonus = agility ~/ 4;
    return PercentValue(
      base: Percent(target.totalArmor - bonus).invert(),
      bonuses: _temporaryEffects.toPercentEffects((e) => e.hitChance),
    );
  }

  Dice? sneakDamage(Entity target) {
    return canSneakAttack(target) ? Skill.sneakAttack.dice : null;
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

  Entity rollEnemy() {
    return Entity(
      'Enemy',
      race: EntityRace.orc,
      klass: EntityClass.random(),
    )
      ..base.roll()
      ..levelUpTo(rollEnemyLevel())
      ..spendAllPoints()
      ..weapon = Weapon.random()
      ..armor = Armor.random();
  }

  int rollEnemyLevel() => const Deviate(2, 0).from(level).withMin(1).roll();

  int xpGain(Entity e) {
    if (level <= e.level) return 3;
    if (level - 1 == e.level) return 2;
    return 1;
  }
}

class _Base {
  final String name;
  final bool player;
  final EntityRace race;
  final EntityClass klass;
  Weapon? weapon;
  Armor? armor;

  _Base(
    this.name, {
    required this.race,
    required this.klass,
    required this.player,
  });
}

mixin _Effects on _Base {
  final _temporaryEffects = Effects();

  Effects get _allEffects {
    final effects = Effects.copy(_temporaryEffects);
    ifdef(weapon, effects.addWeapon);
    ifdef(armor, effects.addArmor);
    return effects;
  }

  void clearSpellEffects() => _temporaryEffects.clearSpells();
  void addSpellEffect(Spell spell) => _temporaryEffects.addSpell(spell);

  bool hasSpellEffect(Spell spell) => _allEffects.hasSpell(spell);
  bool canSpellEffect(Spell spell) {
    if (spell.effect == null) return false;
    if (spell.stacks) return true;
    return !hasSpellEffect(spell);
  }

  void activateSkill() {
    if (klass == EntityClass.warrior) {
      _temporaryEffects.addSkill(Skill.weaponFocus);
    }
  }

  bool hasMaxWeaponDamage() =>
      _allEffects.findEffect((e) => e.maxWeaponDamage) != null;
}

mixin _Attributes on _Base, _Effects {
  var base = EntityAttributes();

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
      bonuses: _allEffects.toIntEffects((e) => e.initiative),
    );
  }

  PercentValue get dodge {
    return PercentValue(
      base: Percent(agility),
      scaling: _allEffects.toPercentEffects((e) => e.dodgeScale),
    );
  }

  PercentValue get resist {
    return PercentValue(
      base: Percent(intellect),
      bonuses: _allEffects.toPercentEffects((e) => e.resistChance),
    );
  }
}

mixin _Health on _Base, _Attributes, _Levels {
  int _damageTaken = 0;

  int get totalHp => strength + level * (klass.hpBonus);
  int get hp => totalHp - _damageTaken;
  bool get injured => _damageTaken > 0;
  bool get alive => hp > 0;
  bool get dead => !alive;

  void resetHp() {
    _damageTaken = 0;
  }

  void heal(int x) {
    _damageTaken -= _damageTaken > x ? x : _damageTaken;
  }

  void takeDamage(int x) {
    _damageTaken += x;
  }
}

mixin _Stress on _Effects, _Attributes, _Levels {
  int _stress = 0;

  int get stress => _stress;
  int get reservedStress => _allEffects.reservedStress;
  int get stressCap => stressCapValue.total - reservedStress;
  IntValue get stressCapValue {
    return IntValue(
      base: intellect + level,
      bonuses: _allEffects.toIntEffects((e) => e.stressCap),
    );
  }

  bool hasStress(int x) => (stress + x) <= stressCap;

  void addStress(int x) {
    _stress += x;
  }

  void clearStress() {
    _stress = 0;
  }
}

mixin _Levels on _Base, _Attributes {
  static const _xpForLevelUp = 3;

  int xp = 0;

  int _extraPoints = 0;
  int _level = 1;

  int get level => _level;
  int get extraPoints => _extraPoints;

  bool canLevelUp() => canLevelUpWith(0);
  bool canLevelUpWith(int x) => (xp + x) >= _xpForLevelUp;

  void levelUp() {
    xp -= _xpForLevelUp;
    ++_level;
    _extraPoints += 2;
  }

  void levelUpTo(int max) {
    while (level < max) {
      levelUp();
    }
  }

  void tryLevelUp() {
    if (canLevelUp()) levelUp();
  }

  void spendPointTo(EntityAttributeId id) {
    base.add(id);
    --_extraPoints;
  }

  void spendAllPoints() {
    while (extraPoints > 0) {
      spendPointTo(EntityAttributeId.random());
    }
  }

  String toXpString() => '$xp/$_xpForLevelUp';
}

mixin _Weapon on _Base, _Effects, _Attributes {
  IntValue get weaponDamageBonus {
    return IntValue(
      base: strength ~/ 2,
      bonuses: _allEffects.toIntEffects((e) => e.damage),
    );
  }

  DiceValue? get weaponDamage {
    if (weapon == null) return null;
    return DiceValue(base: weapon!.dice, bonus: weaponDamageBonus);
  }
}

mixin _Armor on _Base {
  int get totalArmor => armor?.value ?? 0;
}

mixin _Spells on _Base, _Stress {
  bool canCast(Spell spell) => hasStress(spell.stress);

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
}

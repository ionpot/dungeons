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
      bonus: _effects.sumPercent((e) => e.hitChance),
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

  _Base(
    this.name, {
    required this.race,
    required this.klass,
    required this.player,
  });
}

mixin _Effects on _Base {
  final _effects = Effects();

  void clearSpellEffects() => _effects.clearSpells();
  bool hasSpellEffect(Spell spell) => _effects.hasSpell(spell);
  void addSpellEffect(Spell spell) => _effects.addSpell(spell);
  bool canSpellEffect(Spell spell) {
    if (spell.effect == null) return false;
    if (spell.stacks) return true;
    return !_effects.hasSpell(spell);
  }

  void activateSkill() {
    if (klass == EntityClass.warrior) {
      _effects.addSkill(Skill.weaponFocus);
    }
  }
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
      bonus: _effects.sumInt((e) => e.initiative),
    );
  }

  PercentValue get dodge {
    final base = Percent(agility);
    final scale = _effects.sumPercent((e) => e.dodgeScale);
    return PercentValue(base: base, bonus: scale.of(base));
  }

  PercentValue get resist {
    return PercentValue(
      base: Percent(intellect),
      bonus: _effects.sumPercent((e) => e.resistChance),
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
  int get reservedStress => _effects.reservedStress;
  int get stressCap => stressCapValue.total - reservedStress;
  IntValue get stressCapValue {
    return IntValue(
      base: intellect + level,
      bonus: _effects.sumInt((e) => e.stressCap),
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

mixin _Weapon on _Effects, _Attributes {
  Weapon? _weapon;

  Weapon? get weapon => _weapon;

  set weapon(Weapon? w) {
    ifdef(weapon, _effects.removeWeapon);
    _weapon = w;
    ifdef(w, _effects.addWeapon);
  }

  IntValue get weaponDamageBonus {
    return IntValue(
      base: strength ~/ 2,
      bonus: _effects.sumInt((e) => e.damage),
    );
  }

  DiceValue? get weaponDamage {
    if (weapon == null) return null;
    return DiceValue(base: weapon!.dice, bonus: weaponDamageBonus);
  }
}

mixin _Armor on _Effects {
  Armor? _armor;

  Armor? get armor => _armor;

  set armor(Armor? a) {
    ifdef(armor, _effects.removeArmor);
    _armor = a;
    ifdef(a, _effects.addArmor);
  }

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

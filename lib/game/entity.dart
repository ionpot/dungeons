import 'package:dungeons/game/armor.dart';
import 'package:dungeons/game/bonus.dart';
import 'package:dungeons/game/bonuses.dart';
import 'package:dungeons/game/entity_attr.dart';
import 'package:dungeons/game/entity_class.dart';
import 'package:dungeons/game/entity_race.dart';
import 'package:dungeons/game/feat.dart';
import 'package:dungeons/game/gear.dart';
import 'package:dungeons/game/spell.dart';
import 'package:dungeons/game/spellbook.dart';
import 'package:dungeons/game/value.dart';
import 'package:dungeons/game/weapon.dart';
import 'package:dungeons/utility/deviate.dart';
import 'package:dungeons/utility/if.dart';
import 'package:dungeons/utility/percent.dart';

class Entity extends _Base
    with _Gear, _Bonuses, _Attributes, _Levels, _Health, _Stress, _Spells {
  Entity({
    required super.name,
    required super.race,
    super.player = false,
  });

  PercentValue hitChance(Entity target) {
    return PercentValue(
      base: Percent(target.totalArmor).invert(),
      bonuses: PercentBonuses(hitChanceBonusMap),
    );
  }

  BonusMap<Percent> get hitChanceBonusMap {
    return {
      Bonus.agility(): Percent(agility ~/ 4),
      ..._allBonuses.toMap((e) => e.value.hitChance),
    };
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
      name: 'Enemy',
      race: EntityRace.orc,
    )
      ..klass = EntityClass.random()
      ..base.roll()
      ..levelUpTo(rollEnemyLevel())
      ..spendAllPoints()
      ..gear.roll();
  }

  int rollEnemyLevel() => const Deviate(2, 0).from(level).withMin(1).roll();

  int xpGain(Entity e) {
    if (level <= e.level) return 3;
    if (level - 1 == e.level) return 2;
    return 1;
  }

  @override
  String toString() => name;
}

class _Base {
  final String name;
  final bool player;
  final EntityRace race;
  EntityClass? klass;

  _Base({
    required this.name,
    required this.race,
    required this.player,
  });
}

mixin _Gear on _Base {
  var gear = Gear();

  Weapon? get weapon => gear.mainHand;
  Armor? get armor => gear.body;
  int get baseArmor => 5;
  int get totalArmor => baseArmor + gear.armor;

  void equip(Gear gear) {
    this.gear += gear;
  }
}

mixin _Bonuses on _Base, _Gear {
  final _extraBonuses = Bonuses();

  Bonuses get _allBonuses {
    final bonuses = gear.bonuses;
    if (klass == EntityClass.warrior) {
      bonuses.addFeat(Feat.weaponFocus);
    }
    return bonuses..addAll(_extraBonuses);
  }

  void clearSpellBonuses() => _extraBonuses.clearSpells();
  void addSpellBonus(Spell spell) => _extraBonuses.addSpell(spell);

  bool hasSpellBonus(Spell spell) => _allBonuses.hasSpell(spell);
  bool canSpellEffect(Spell spell) {
    if (spell.effect == null) return false;
    if (spell.stacks) return true;
    return !hasSpellBonus(spell);
  }
}

mixin _Attributes on _Base, _Gear, _Bonuses {
  final base = EntityAttributes();

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
      bonuses: IntBonuses(
        _allBonuses.toMap((e) => e.value.initiative),
      ),
    );
  }

  PercentValue get dodge {
    return PercentValue(
      base: Percent(agility),
      multipliers: MultiplierBonuses(
        _allBonuses.toMap((e) => e.value.dodgeMultiplier),
      ),
    );
  }

  PercentValue get resist {
    return PercentValue(
      base: Percent(intellect),
      bonuses: PercentBonuses(
        _allBonuses.toMap((e) => e.value.resistChance),
      ),
    );
  }

  DiceValue? get weaponDamage {
    if (weapon == null) return null;
    return DiceValue(
      base: weapon!.dice.addBonus(strength ~/ 2),
      intBonuses: IntBonuses(_allBonuses.toMap((e) => e.value.damage)),
      max: _allBonuses.findBonus((e) => e.value.maxWeaponDamage) != null,
    );
  }

  bool get canDodge => initiative.total > 0;
}

mixin _Health on _Base, _Attributes, _Levels {
  int _damageTaken = 0;

  int get totalHp => strength + level * (klass?.hpBonus ?? 0);
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

mixin _Stress on _Bonuses, _Attributes, _Levels {
  int _stress = 0;

  int get stress => _stress;

  IntBonuses get reservedStress =>
      IntBonuses(_allBonuses.toMap((e) => e.bonus.reservedStress));

  int get stressCap => stressCapValue.total - reservedStress.total;

  IntValue get stressCapValue {
    return IntValue(
      base: intellect + level,
      bonuses: IntBonuses(_allBonuses.toMap((e) => e.value.stressCap)),
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

mixin _Spells on _Base, _Stress {
  bool canCast(Spell spell) => hasStress(spell.stress);

  SpellBook? get spellbook => ifdef(klass?.spells, SpellBook.new);

  Set<Spell> get knownSpells => spellbook?.spells ?? {};
}

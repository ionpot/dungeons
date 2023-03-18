import 'package:dungeons/game/armor.dart';
import 'package:dungeons/game/bonus.dart';
import 'package:dungeons/game/bonuses.dart';
import 'package:dungeons/game/critical_hit.dart';
import 'package:dungeons/game/entity_attr.dart';
import 'package:dungeons/game/entity_class.dart';
import 'package:dungeons/game/entity_feats.dart';
import 'package:dungeons/game/entity_race.dart';
import 'package:dungeons/game/feat.dart';
import 'package:dungeons/game/gear.dart';
import 'package:dungeons/game/spell.dart';
import 'package:dungeons/game/spellbook.dart';
import 'package:dungeons/game/value.dart';
import 'package:dungeons/game/weapon.dart';
import 'package:dungeons/utility/deviate.dart';
import 'package:dungeons/utility/percent.dart';
import 'package:dungeons/utility/pick_random.dart';

class Entity extends _Base
    with
        _Gear,
        _Feats,
        _Bonuses,
        _Attributes,
        _Levels,
        _Health,
        _Stress,
        _Spells {
  Entity({
    required super.name,
    required super.race,
    super.infiniteStress = false,
  });

  PercentValue hitChance(Entity target) {
    return PercentValue(
      base: hitChanceBase(target),
      bonuses: PercentBonuses(hitChanceBonusMap),
    );
  }

  Percent hitChanceBase(Entity target) {
    return Percent(target.totalArmor).invert();
  }

  PercentValue get criticalHitChance {
    return PercentValue(
      base: const Percent(0),
      bonuses: PercentBonuses(
        _allBonuses.toMap((e) => e.criticalHitChance),
      ),
    );
  }

  BonusMap<Percent> get hitChanceBonusMap {
    return {
      Bonus.agility(): Percent(agility ~/ 4),
      ..._allBonuses.toMap((e) => e.hitChance),
    };
  }

  // -1 if this is faster
  // 1 if other is faster
  int compareSpeed(Entity other) {
    final i = initiative.compareTo(other.initiative);
    if (i != 0) return i * -1;
    return totalArmor.compareTo(other.totalArmor);
  }

  CriticalHit get criticalHit {
    return CriticalHit(chance: criticalHitChance, dice: gear.weaponValue!.dice);
  }

  FeatSlot? sneakAttack(Entity target) {
    return initiative > target.initiative ? feats.find(Feat.sneakAttack) : null;
  }

  Entity rollEnemy() {
    return Entity(
      name: 'Enemy',
      race: EntityRace.orc,
      infiniteStress: true,
    )
      ..klass = EntityClass.random()
      ..base.roll()
      ..levelUpTo(rollEnemyLevel())
      ..spendAllPoints()
      ..rollGear();
  }

  int rollEnemyLevel() => const Deviate(2, 0).from(level).withMin(1).roll();

  Gear rollGear() {
    final mainHand = Weapon.randomMainHand();
    return Gear(
      body: Armor.random(),
      mainHand: mainHand,
      offHand: mainHand.canOneHand ? rollOffHand() : null,
    );
  }

  Weapon? rollOffHand() {
    if (klass == null) {
      return null;
    }
    return pickRandomMaybe(Weapon.forOffHand.where(klass!.canOffHand));
  }

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
  final EntityRace race;
  final bool infiniteStress;
  EntityClass? klass;
  int level = 1;

  _Base({
    required this.name,
    required this.race,
    required this.infiniteStress,
  });
}

mixin _Gear on _Base {
  var gear = Gear();

  Weapon? get weapon => gear.mainHand;
  Weapon? get offHandWeapon => gear.offHand;
  Weapon? get shield => gear.shield;
  Armor? get armor => gear.body;
  int get baseArmor => 5;
  int get totalArmor => baseArmor + gear.armor;

  bool canEquip(Gear gear) {
    if (klass == null) {
      return false;
    }
    if (gear.offHand != null) {
      if (!klass!.canOffHand(gear.offHand!)) {
        return false;
      }
    }
    return this.gear.canEquip(gear);
  }

  void equip(Gear gear) {
    this.gear += gear;
  }
}

mixin _Feats on _Base {
  EntityFeats get feats {
    final tier = FeatTier.forLevel(level);
    return EntityFeats({
      if (klass == EntityClass.warrior) Feat.weaponFocus: tier,
      if (klass == EntityClass.trickster) Feat.sneakAttack: tier,
    });
  }
}

mixin _Bonuses on _Base, _Gear, _Feats {
  final _extraBonuses = Bonuses();

  Bonuses get _allBonuses {
    return gear.bonuses + feats.bonuses + _extraBonuses;
  }

  void clearSpellBonuses() {
    _extraBonuses.clear();
  }

  void addSpellBonus(Spell spell) {
    _extraBonuses.add(Bonus(spell: spell), spell.effect);
  }

  bool hasSpellBonus(Spell spell) => _allBonuses.has(Bonus(spell: spell));
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
        _allBonuses.toMap((e) => e.initiative),
      ),
    );
  }

  PercentValue get dodge {
    return PercentValue(
      base: Percent(agility),
      multipliers: MultiplierBonuses(
        _allBonuses.toMap((e) => e.dodgeMultiplier),
      ),
    );
  }

  PercentValue get resist {
    return PercentValue(
      base: Percent(intellect),
      bonuses: PercentBonuses(
        _allBonuses.toMap((e) => e.resistChance),
      ),
    );
  }

  DiceValue? get weaponDamage {
    final weapon = gear.weaponValue;
    if (weapon == null) return null;
    return DiceValue(
      base: weapon.dice.addBonus(strength ~/ 2),
      intBonuses: IntBonuses(_allBonuses.toMap((e) => e.damage)),
      max: _allBonuses.findBonus((e) => e.maxWeaponDamage),
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
  final BonusMap<int> _reserved = {};
  int _stress = 0;

  int get stress => _stress;

  IntBonuses get reservedStress => feats.reserveStress + IntBonuses(_reserved);

  int get stressCap => stressCapValue.total - reservedStress.total;

  IntValue get stressCapValue {
    return IntValue(
      base: intellect + level,
      bonuses: IntBonuses(_allBonuses.toMap((e) => e.stressCap)),
    );
  }

  bool hasStress(int x) => infiniteStress || (stress + x) <= stressCap;
  bool alreadyReserved(Bonus bonus) => _reserved.keys.contains(bonus);

  void addStress(int x) {
    if (!infiniteStress) {
      _stress += x;
    }
  }

  void clearStress() {
    _stress = 0;
    _reserved.clear();
  }

  void reserveStressFor(Bonus bonus, int amount) {
    _reserved[bonus] = amount;
  }
}

mixin _Levels on _Base, _Attributes {
  static const _xpForLevelUp = 3;

  int xp = 0;

  int _extraPoints = 0;

  int get extraPoints => _extraPoints;

  bool canLevelUp() => canLevelUpWith(0);
  bool canLevelUpWith(int x) => (xp + x) >= _xpForLevelUp;

  void levelUp() {
    xp -= _xpForLevelUp;
    ++level;
    _extraPoints += 2;
  }

  void levelUpTo(int max) {
    while (level < max) {
      xp += _xpForLevelUp;
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
  bool canCast(Spell spell) {
    return hasStress(spell.stress) && !alreadyReserved(Bonus(spell: spell));
  }

  SpellBook get spellbook => SpellBook(klass?.spells ?? {});

  Set<Spell> get knownSpells => spellbook.spellsForLevel(level);

  Spell? maybeRandomSpell() {
    return pickRandomMaybe(knownSpells);
  }
}

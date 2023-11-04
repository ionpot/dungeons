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
import 'package:dungeons/utility/percent.dart';
import 'package:dungeons/utility/random.dart';

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
      Bonus.baseAgility: Percent(agility.base ~/ 4),
      Bonus.bonusAgility: Percent(agility.bonus ~/ 4),
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

  Bonuses get _raceBonuses {
    return Bonuses({
      if (race.effect != null) Bonus(race: race): race.effect!,
    });
  }

  Bonuses get _allBonuses {
    return _raceBonuses + gear.bonuses + feats.bonuses + _extraBonuses;
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

  IntValue get strength {
    return IntValue(
      base: base.strength,
      bonuses: IntBonuses(_allBonuses.toMap((e) => e.strength)),
    );
  }

  IntValue get agility {
    return IntValue(
      base: base.agility,
      bonuses: IntBonuses(_allBonuses.toMap((e) => e.agility)),
    );
  }

  IntValue get intellect {
    return IntValue(
      base: base.intellect,
      bonuses: IntBonuses(_allBonuses.toMap((e) => e.intellect)),
    );
  }

  EntityAttributes get attributes {
    return EntityAttributes(
      strength: strength.total,
      agility: agility.total,
      intellect: intellect.total,
    );
  }

  IntValue get initiative {
    final bonus = (agility.bonus + intellect.bonus) ~/ 2;
    return IntValue(
      base: (agility.base + intellect.base) ~/ 2,
      bonuses: IntBonuses({
        if (bonus != 0) Bonus.attributes(): bonus,
        ..._allBonuses.toMap((e) => e.initiative),
      }),
    );
  }

  PercentValue get dodge {
    return PercentValue(
      base: Percent(agility.base),
      bonuses: PercentBonuses({
        if (agility.bonus != 0) Bonus.bonusAgility: Percent(agility.bonus),
      }),
      multipliers: MultiplierBonuses(
        _allBonuses.toMap((e) => e.dodgeMultiplier),
      ),
    );
  }

  PercentValue get resist {
    return PercentValue(
      base: Percent(intellect.base),
      bonuses: PercentBonuses({
        if (intellect.bonus != 0)
          Bonus.bonusIntellect: Percent(intellect.bonus),
        ..._allBonuses.toMap((e) => e.resistChance),
      }),
    );
  }

  DiceValue? get weaponDamage {
    final weapon = gear.weaponValue;
    if (weapon == null) return null;
    final bonus = strength.bonus ~/ 2;
    return DiceValue(
      base: weapon.dice,
      intBonuses: IntBonuses({
        Bonus.baseStrength: strength.base ~/ 2,
        if (bonus != 0) Bonus.bonusStrength: bonus,
        ..._allBonuses.toMap((e) => e.damage),
      }),
      max: _allBonuses.findBonus((e) => e.maxWeaponDamage),
    );
  }

  bool get canDodge => initiative.total > 0;
}

mixin _Health on _Base, _Attributes, _Levels {
  int _damageTaken = 0;

  IntValue get totalHp {
    final classBonus = level * (klass?.hpBonus ?? 0);
    return IntValue(
      base: strength.base,
      bonuses: IntBonuses({
        if (classBonus != 0) Bonus(klass: klass, level: level): classBonus,
        if (strength.bonus != 0) Bonus.bonusStrength: strength.bonus,
      }),
    );
  }

  int get hp => totalHp.total - _damageTaken;
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
      base: intellect.base + level,
      bonuses: IntBonuses({
        Bonus(level: level): level,
        if (intellect.bonus != 0) Bonus.bonusIntellect: intellect.bonus,
        ..._allBonuses.toMap((e) => e.stressCap),
      }),
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
  bool get hasPointsToSpend => _extraPoints > 0;

  void addXp(int amount) {
    xp += amount;
    while (canLevelUp()) {
      xp -= _xpForLevelUp;
      levelUp();
    }
  }

  void levelUp() {
    ++level;
    _extraPoints += 2;
  }

  void levelUpTo(int max) {
    while (level < max) {
      levelUp();
    }
  }

  void spendPointTo(EntityAttributeId id) {
    base.add(id);
    --_extraPoints;
  }

  void spendAllPoints() {
    while (hasPointsToSpend) {
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

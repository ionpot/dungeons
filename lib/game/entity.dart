import "package:dungeons/game/armor.dart";
import "package:dungeons/game/bonus.dart";
import "package:dungeons/game/bonus_entry.dart";
import "package:dungeons/game/bonus_pool.dart";
import "package:dungeons/game/bonus_value.dart";
import "package:dungeons/game/bonuses.dart";
import "package:dungeons/game/dice_value.dart";
import "package:dungeons/game/entity_attr.dart";
import "package:dungeons/game/entity_class.dart";
import "package:dungeons/game/entity_feats.dart";
import "package:dungeons/game/entity_race.dart";
import "package:dungeons/game/feat.dart";
import "package:dungeons/game/gear.dart";
import "package:dungeons/game/spell.dart";
import "package:dungeons/game/spellbook.dart";
import "package:dungeons/game/status_effect.dart";
import "package:dungeons/game/status_effects.dart";
import "package:dungeons/game/value.dart";
import "package:dungeons/game/weapon.dart";
import "package:dungeons/utility/monoids.dart";
import "package:dungeons/utility/random.dart";

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

  Value<Percent> hitChance(Entity target) {
    return Value.from(
      hitChanceBase(target),
      hitChanceBonuses,
    );
  }

  Percent hitChanceBase(Entity target) {
    return Percent(target.totalArmor).invert();
  }

  Value<Percent> get criticalHitChance {
    return Value.from(
      Percent.zero,
      _allBonuses.percents(PercentBonusTo.criticalHit),
    );
  }

  Bonuses<Percent> get hitChanceBonuses {
    final base = agility.base.half;
    final bonus = agility.bonus.quarter as Int;
    final bonuses = Bonuses({
      AttributeBonus.baseAgility: Percent(base.value),
      AttributeBonus.bonusAgility: Percent(bonus.value),
    });
    return bonuses + _allBonuses.percents(PercentBonusTo.toHit);
  }

  // -1 if this is faster
  // 1 if other is faster
  int compareSpeed(Entity other) {
    final i = initiative.compareTo(other.initiative);
    if (i != 0) return i * -1;
    return totalArmor.compareTo(other.totalArmor);
  }

  bool fasterThan(Entity other) {
    return compareSpeed(other) == -1;
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
  final effects = StatusEffects.empty();

  BonusPool get _raceBonuses {
    return BonusPool.empty()..addValues(RaceBonus(race), race.bonuses);
  }

  BonusPool get _allBonuses {
    return _raceBonuses + gear.bonuses + feats.bonuses + effects.bonuses;
  }

  bool hasBonus(Bonus bonus) => _allBonuses.has(bonus);
}

mixin _Attributes on _Base, _Gear, _Bonuses {
  final base = EntityAttributes();

  EntityAttributes get attributes {
    return EntityAttributes(
      strength: strength.total.value,
      agility: agility.total.value,
      intellect: intellect.total.value,
    );
  }

  Value<Int> get strength {
    return Value.from(
      Int(base.strength),
      _allBonuses.ints(IntBonusTo.strength),
    );
  }

  Value<Int> get agility {
    return Value.from(
      Int(base.agility),
      _allBonuses.ints(IntBonusTo.agility),
    );
  }

  Value<Int> get intellect {
    return Value.from(
      Int(base.intellect),
      _allBonuses.ints(IntBonusTo.intellect),
    );
  }

  Value<Int> get initiative {
    final base = agility.base + intellect.base;
    final bonus = agility.bonus + intellect.bonus;
    final bonuses = Bonuses({
      AttributeBonus.baseAttributes: Int(bonus.value ~/ 2),
    });
    return Value.from(
      Int(base.value ~/ 2),
      bonuses + _allBonuses.ints(IntBonusTo.initiative),
    );
  }

  Value<Percent> get dodge {
    return Value.from(
      Percent(agility.base.value),
      Bonuses({
        AttributeBonus.bonusAgility: Percent(agility.bonus.value),
      }),
      multipliers: _allBonuses.multipliers(MultiplierBonusTo.dodge),
    );
  }

  Value<Percent> get resist {
    final bonuses = Bonuses({
      AttributeBonus.bonusIntellect: Percent(intellect.bonus.value),
    });
    return Value.from(
      Percent(intellect.base.value),
      bonuses + _allBonuses.percents(PercentBonusTo.resist),
    );
  }

  DiceValue? get weaponDamage {
    final weapon = gear.weaponValue;
    if (weapon == null) return null;
    final bonuses = Bonuses({
      AttributeBonus.baseStrength: strength.base.half,
      AttributeBonus.bonusStrength: strength.bonus.half,
    });
    return DiceValue(
      base: weapon.dice,
      intBonuses: bonuses + _allBonuses.ints(IntBonusTo.damage),
      max: effects.findBonusOf(StatusEffect.maxDamage),
    );
  }

  bool get canDodge => initiative.total.value > 0;
}

mixin _Health on _Base, _Attributes, _Levels {
  int _damageTaken = 0;

  Value<Int> get totalHp {
    return Value.from(
      strength.base,
      Bonuses({
        ClassBonus(klass, level): Int(level * (klass?.hpBonus ?? 0)),
        AttributeBonus.bonusStrength: strength.bonus,
      }),
    );
  }

  int get hp => totalHp.total.value - _damageTaken;
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
  final List<BonusEntry<Int>> _reserved = [];
  int _stress = 0;

  int get stress => _stress;

  List<BonusEntry<Int>> get reservedStress => feats.reserveStress + _reserved;

  Value<Int> get stressCap {
    final bonuses = Bonuses({
      ClassBonus.level(level): Int(level),
      AttributeBonus.bonusIntellect: intellect.bonus,
    });
    return Value(
      intellect.base + Int(level),
      bonuses + _allBonuses.ints(IntBonusTo.stressCap),
      multipliers: Bonuses.empty(),
      reserved: reservedStress,
    );
  }

  bool hasStress(int x) =>
      infiniteStress || stressCap.total.contains(_stress + x);

  void addStress(int x) {
    _stress += x;
  }

  void clearStress() {
    _stress = 0;
    _reserved.clear();
  }

  void reserveStressFor(Bonus bonus, int amount) {
    _reserved.add(BonusEntry(bonus, Int(amount)));
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

  String toXpString() => "$xp/$_xpForLevelUp";
}

mixin _Spells on _Base, _Stress {
  bool canCast(Spell spell) => hasStress(spell.stress);

  SpellBook get spellbook => SpellBook(klass?.spells ?? {});

  Set<Spell> get knownSpells => spellbook.spellsForLevel(level);

  Spell? maybeRandomSpell() {
    return pickRandomMaybe(knownSpells);
  }
}

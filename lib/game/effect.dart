import "package:dungeons/utility/multiplier.dart";
import "package:dungeons/utility/percent.dart";

class Effect {
  final int? strength;
  final int? agility;
  final int? intellect;
  final int? armor;
  final int? damage;
  final int? initiative;
  final int? stressCap;
  final Multiplier? dodgeMultiplier;
  final Percent? hitChance;
  final Percent? criticalHitChance;
  final Percent? resistChance;
  final bool maxWeaponDamage;

  const Effect({
    this.strength,
    this.agility,
    this.intellect,
    this.armor,
    this.damage,
    this.initiative,
    this.stressCap,
    this.dodgeMultiplier,
    this.hitChance,
    this.criticalHitChance,
    this.resistChance,
    this.maxWeaponDamage = false,
  });

  Effect operator +(Effect other) {
    return Effect(
      strength: _addInt(strength, other.strength),
      agility: _addInt(agility, other.agility),
      intellect: _addInt(intellect, other.intellect),
      armor: _addInt(armor, other.armor),
      damage: _addInt(damage, other.damage),
      initiative: _addInt(initiative, other.initiative),
      stressCap: _addInt(stressCap, other.stressCap),
      dodgeMultiplier: _addMultiplier(dodgeMultiplier, other.dodgeMultiplier),
      hitChance: _addPercent(hitChance, other.hitChance),
      criticalHitChance:
          _addPercent(criticalHitChance, other.criticalHitChance),
      resistChance: _addPercent(resistChance, other.resistChance),
      maxWeaponDamage: maxWeaponDamage || other.maxWeaponDamage,
    );
  }

  int? _addInt(int? a, int? b) {
    if (a == null) return b;
    if (b == null) return a;
    return a + b;
  }

  Percent? _addPercent(Percent? a, Percent? b) {
    if (a == null) return b;
    if (b == null) return a;
    return a + b;
  }

  Multiplier? _addMultiplier(Multiplier? a, Multiplier? b) {
    if (a == null) return b;
    if (b == null) return a;
    return a + b;
  }
}

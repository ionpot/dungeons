import 'package:dungeons/utility/multiplier.dart';
import 'package:dungeons/utility/percent.dart';

class Effect {
  final int? damage;
  final int? initiative;
  final int? stressCap;
  final Multiplier? dodgeMultiplier;
  final Percent? hitChance;
  final Percent? resistChance;
  final bool maxWeaponDamage;

  const Effect({
    this.damage,
    this.initiative,
    this.stressCap,
    this.dodgeMultiplier,
    this.hitChance,
    this.resistChance,
    this.maxWeaponDamage = false,
  });

  Effect operator +(Effect other) {
    return Effect(
      damage: _addInt(damage, other.damage),
      initiative: _addInt(initiative, other.initiative),
      stressCap: _addInt(stressCap, other.stressCap),
      dodgeMultiplier: _addMultiplier(dodgeMultiplier, other.dodgeMultiplier),
      hitChance: _addPercent(hitChance, other.hitChance),
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

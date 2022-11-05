import 'package:dungeons/utility/percent.dart';

class EffectBonus {
  final int? damage;
  final int? initiative;
  final Percent? dodgeScale;
  final Percent? hitChance;

  const EffectBonus({
    this.damage,
    this.initiative,
    this.dodgeScale,
    this.hitChance,
  });

  EffectBonus operator +(EffectBonus other) {
    return EffectBonus(
      damage: _addInt(damage, other.damage),
      initiative: _addInt(initiative, other.initiative),
      dodgeScale: _addPercent(dodgeScale, other.dodgeScale),
      hitChance: _addPercent(hitChance, other.hitChance),
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
}

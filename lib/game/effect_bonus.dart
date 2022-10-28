import 'package:dungeons/utility/percent.dart';

class EffectBonus {
  final int? damage;
  final int? initiative;
  final int? reserveStress;
  final Percent? dodgeScale;
  final Percent? hitChance;

  const EffectBonus({
    this.damage,
    this.initiative,
    this.reserveStress,
    this.dodgeScale,
    this.hitChance,
  });
}

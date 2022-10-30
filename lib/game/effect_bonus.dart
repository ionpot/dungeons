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
}

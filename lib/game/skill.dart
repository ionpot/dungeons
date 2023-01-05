import 'package:dungeons/game/effect_bonus.dart';
import 'package:dungeons/utility/dice.dart';
import 'package:dungeons/utility/percent.dart';

enum Skill {
  weaponFocus(
    text: 'Weapon Focus',
    bonus: EffectBonus(hitChance: Percent(2), damage: 1),
    reserveStress: 1,
  ),
  sneakAttack(text: 'Sneak Attack', dice: Dice(1, 6));

  final String text;
  final EffectBonus? bonus;
  final int? reserveStress;
  final Dice? dice;

  const Skill({required this.text, this.bonus, this.reserveStress, this.dice});
}

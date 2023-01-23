import 'package:dungeons/game/effect.dart';
import 'package:dungeons/utility/dice.dart';
import 'package:dungeons/utility/percent.dart';

enum Feat {
  weaponFocus(
    text: 'Weapon Focus',
    effect: Effect(hitChance: Percent(2), damage: 1),
    reserveStress: 1,
  ),
  sneakAttack(text: 'Sneak Attack', dice: Dice(1, 6));

  final String text;
  final Effect? effect;
  final int? reserveStress;
  final Dice? dice;

  const Feat({required this.text, this.effect, this.reserveStress, this.dice});
}

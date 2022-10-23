import 'package:dungeons/game/effect_bonus.dart';
import 'package:dungeons/utility/dice.dart';
import 'package:dungeons/utility/pick_random.dart';

enum Weapon {
  dagger(text: 'Dagger', dice: Dice.sides(4), initiative: 2),
  mace(text: 'Mace', dice: Dice.sides(6)),
  longsword(text: 'Longsword', dice: Dice.sides(8)),
  halberd(text: 'Halberd', dice: Dice.sides(10), initiative: -2);

  final Dice dice;
  final int initiative;
  final String text;

  const Weapon({
    required this.text,
    required this.dice,
    this.initiative = 0,
  });

  factory Weapon.random() => pickRandom(Weapon.values);

  EffectBonus get bonus => EffectBonus(initiative: initiative);

  @override
  String toString() => text;
}

import 'package:dungeons/utility/dice.dart';
import 'package:dungeons/utility/has_text.dart';

enum EntityWeapon implements HasText {
  dagger(text: 'Dagger', dice: Dice.sides(4), initiative: 2),
  mace(text: 'Mace', dice: Dice.sides(6)),
  longsword(text: 'Longsword', dice: Dice.sides(8)),
  halberd(text: 'Halberd', dice: Dice.sides(10), initiative: -2);

  const EntityWeapon({
    required this.text,
    required this.dice,
    this.initiative = 0,
  });

  final Dice dice;
  final int initiative;

  @override
  final String text;
}

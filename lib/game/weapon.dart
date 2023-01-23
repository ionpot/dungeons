import 'package:dungeons/game/effect.dart';
import 'package:dungeons/utility/dice.dart';
import 'package:dungeons/utility/pick_random.dart';

enum Weapon {
  dagger(text: 'Dagger', dice: Dice(1, 4), initiative: 2),
  mace(text: 'Mace', dice: Dice(1, 6)),
  longsword(text: 'Longsword', dice: Dice(1, 8)),
  halberd(text: 'Halberd', dice: Dice(1, 10), initiative: -2);

  final Dice dice;
  final int initiative;
  final String text;

  const Weapon({
    required this.text,
    required this.dice,
    this.initiative = 0,
  });

  factory Weapon.random() => pickRandom(Weapon.values);

  Effect get effect => Effect(initiative: initiative);

  @override
  String toString() => text;
}

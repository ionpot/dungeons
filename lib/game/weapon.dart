import 'package:dungeons/game/effect.dart';
import 'package:dungeons/utility/dice.dart';
import 'package:dungeons/utility/pick_random.dart';

enum Weapon {
  dagger(text: 'Dagger', group: WeaponGroup.small),
  mace(text: 'Mace', group: WeaponGroup.medium),
  longsword(text: 'Longsword', group: WeaponGroup.hybrid),
  halberd(text: 'Halberd', group: WeaponGroup.large);

  final WeaponGroup group;
  final String text;

  const Weapon({
    required this.text,
    required this.group,
  });

  factory Weapon.random() => pickRandom(Weapon.values);

  @override
  String toString() => text;
}

enum WeaponGroup {
  small(oneHanded: WeaponValue(dice: Dice(1, 4), initiative: 2)),
  medium(oneHanded: WeaponValue(dice: Dice(1, 6))),
  hybrid(
    oneHanded: WeaponValue(dice: Dice(1, 6)),
    twoHanded: WeaponValue(dice: Dice(1, 8)),
  ),
  large(twoHanded: WeaponValue(dice: Dice(1, 10), initiative: -2));

  final WeaponValue? oneHanded;
  final WeaponValue? twoHanded;

  const WeaponGroup({this.oneHanded, this.twoHanded});
}

class WeaponValue {
  final Dice dice;
  final int initiative;

  const WeaponValue({required this.dice, this.initiative = 0});

  Effect? get effect => initiative != 0 ? Effect(initiative: initiative) : null;
}

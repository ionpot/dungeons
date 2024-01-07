import "package:dungeons/game/bonus_value.dart";
import "package:dungeons/utility/dice.dart";
import "package:dungeons/utility/random.dart";

enum Weapon {
  dagger(
    text: "Dagger",
    group: WeaponGroup.small,
    mainHand: WeaponValue(dice: Dice(1, 4), initiative: 2),
    offHand: WeaponValue(dice: Dice(1, 4)),
  ),
  mace(
    text: "Mace",
    group: WeaponGroup.medium,
    mainHand: WeaponValue(dice: Dice(1, 6)),
  ),
  longsword(
    text: "Longsword",
    group: WeaponGroup.hybrid,
    mainHand: WeaponValue(dice: Dice(1, 6)),
    twoHanded: WeaponValue(dice: Dice(1, 8)),
  ),
  halberd(
    text: "Halberd",
    group: WeaponGroup.large,
    twoHanded: WeaponValue(dice: Dice(1, 10), initiative: -2),
  ),
  shield(
    text: "Shield",
    group: WeaponGroup.shield,
    offHand: WeaponValue(armor: 5),
  ),
  shortbow(
    text: "Shortbow",
    group: WeaponGroup.bow,
    twoHanded: WeaponValue(dice: Dice(1, 6), initiative: 4),
  );

  final String text;
  final WeaponGroup group;
  final WeaponValue? mainHand;
  final WeaponValue? offHand;
  final WeaponValue? twoHanded;

  const Weapon({
    required this.text,
    required this.group,
    this.mainHand,
    this.offHand,
    this.twoHanded,
  });

  bool get oneHanded => mainHand != null;
  bool get twoHandOnly => twoHanded != null && (mainHand ?? offHand) == null;
  bool get offHandOnly => offHand != null && (mainHand ?? twoHanded) == null;

  @override
  String toString() => text;

  static Iterable<Weapon> forMainHand =
      values.where((weapon) => !weapon.offHandOnly);
  static Iterable<Weapon> forOffHand =
      values.where((weapon) => weapon.offHand != null);
  static BonusValue offHandPenalty = const IntBonus.initiative(-2);

  static Weapon randomMainHand() => pickRandom(forMainHand);
}

enum WeaponGroup {
  small,
  medium,
  hybrid,
  large,
  shield,
  bow;

  static const melee = {small, medium, hybrid, large};
  static const forMainHand = {...melee, bow};
  static const forOffHand = {small, shield};
}

class WeaponValue {
  final int armor;
  final int initiative;
  final Dice? dice;

  const WeaponValue({this.armor = 0, this.initiative = 0, this.dice});

  BonusValue get bonus => IntBonus.initiative(initiative);
}

import 'package:dungeons/game/effect.dart';
import 'package:dungeons/utility/dice.dart';
import 'package:dungeons/utility/pick_random.dart';

enum Weapon {
  dagger(text: 'Dagger', group: WeaponGroup.small),
  mace(text: 'Mace', group: WeaponGroup.medium),
  longsword(text: 'Longsword', group: WeaponGroup.hybrid),
  halberd(text: 'Halberd', group: WeaponGroup.large),
  shield(text: 'Shield', group: WeaponGroup.shield);

  final WeaponGroup group;
  final String text;

  const Weapon({
    required this.text,
    required this.group,
  });

  int? get armor => group.armor;

  bool get canAttack => group.canAttack;
  bool get canOneHand => group.canOneHand;
  bool get canMainHand => group.canMainHand;
  bool get canOffHand => group.canOffHand;
  bool get twoHandOnly => group.twoHandOnly;

  @override
  String toString() => text;

  static Iterable<Weapon> forMainHand =
      values.where((weapon) => weapon.canMainHand);
  static Iterable<Weapon> forOffHand =
      values.where((weapon) => weapon.canOffHand);
  static Effect offHandPenalty = const Effect(initiative: -2);

  static Weapon randomMainHand() => pickRandom(forMainHand);
  static Weapon? maybeRandomOffHand() => pickRandomMaybe(forOffHand);
}

enum WeaponGroup {
  small(oneHanded: WeaponValue(dice: Dice(1, 4), initiative: 2)),
  medium(oneHanded: WeaponValue(dice: Dice(1, 6))),
  hybrid(
    oneHanded: WeaponValue(dice: Dice(1, 6)),
    twoHanded: WeaponValue(dice: Dice(1, 8)),
  ),
  large(twoHanded: WeaponValue(dice: Dice(1, 10), initiative: -2)),
  shield(armor: 3);

  final WeaponValue? oneHanded;
  final WeaponValue? twoHanded;
  final int? armor;

  const WeaponGroup({this.oneHanded, this.twoHanded, this.armor});

  bool get canAttack => oneHanded != null || twoHanded != null;
  bool get canOneHand => oneHanded != null;
  bool get canMainHand => mainHand.contains(this);
  bool get canOffHand => offHand.contains(this);
  bool get twoHandOnly => oneHanded == null && twoHanded != null;
  bool get offHandOnly => oneHanded == null && twoHanded == null;

  static const Set<WeaponGroup> mainHand = {small, medium, hybrid, large};
  static const Set<WeaponGroup> offHand = {small, shield};
}

class WeaponValue {
  final Dice dice;
  final int initiative;

  const WeaponValue({required this.dice, this.initiative = 0});

  Effect? get effect => initiative != 0 ? Effect(initiative: initiative) : null;
}

import 'package:dungeons/game/spell.dart';
import 'package:dungeons/game/weapon.dart';
import 'package:dungeons/utility/pick_random.dart';

enum EntityClass {
  warrior(
    text: 'Warrior',
    hpBonus: 4,
  ),
  trickster(
    text: 'Trickster',
    hpBonus: 3,
    offHand: {WeaponGroup.small},
  ),
  cleric(
    text: 'Cleric',
    hpBonus: 3,
    offHand: {WeaponGroup.shield},
    spells: {Spell.bless, Spell.heal},
  ),
  mage(
    text: 'Mage',
    hpBonus: 2,
    offHand: {},
    spells: {Spell.magicMissile, Spell.rayOfFrost, Spell.lightningBolt},
  );

  final int hpBonus;
  final String text;
  final Set<WeaponGroup>? offHand;
  final Set<Spell>? spells;

  const EntityClass({
    required this.text,
    required this.hpBonus,
    this.offHand,
    this.spells,
  });

  factory EntityClass.random() => pickRandom(EntityClass.values);

  bool canOffHand(Weapon weapon) {
    if (offHand == null) {
      return true;
    }
    return offHand!.contains(weapon.group);
  }

  @override
  String toString() => text;
}

import "package:dungeons/game/feat.dart";
import "package:dungeons/game/spell.dart";
import "package:dungeons/game/weapon.dart";
import "package:dungeons/utility/random.dart";

enum EntityClass {
  warrior(
    text: "Warrior",
    hpBonus: 4,
    feat: Feat.weaponFocus,
    mainHand: WeaponGroup.forMainHand,
    offHand: WeaponGroup.forOffHand,
  ),
  trickster(
    text: "Trickster",
    hpBonus: 3,
    feat: Feat.sneakAttack,
    mainHand: WeaponGroup.forMainHand,
    offHand: {WeaponGroup.small},
  ),
  cleric(
    text: "Cleric",
    hpBonus: 3,
    mainHand: WeaponGroup.melee,
    offHand: {WeaponGroup.shield},
    spells: {Spell.bless, Spell.heal},
  ),
  mage(
    text: "Mage",
    hpBonus: 2,
    mainHand: WeaponGroup.melee,
    spells: {Spell.magicMissile, Spell.rayOfFrost, Spell.lightningBolt},
  ),
  monster(
    text: "Monster",
    hpBonus: 4,
    mainHand: WeaponGroup.forMainHand,
    offHand: {WeaponGroup.small},
  );

  static const Set<EntityClass> playable = {
    EntityClass.warrior,
    EntityClass.trickster,
    EntityClass.cleric,
    EntityClass.mage,
  };

  final int hpBonus;
  final String text;
  final Set<WeaponGroup> mainHand;
  final Set<WeaponGroup>? offHand;
  final Feat? feat;
  final Set<Spell>? spells;

  const EntityClass({
    required this.text,
    required this.hpBonus,
    required this.mainHand,
    this.offHand,
    this.feat,
    this.spells,
  });

  factory EntityClass.random() => pickRandom(EntityClass.values);

  bool canMainHand(Weapon weapon) {
    return mainHand.contains(weapon.group);
  }

  bool canOffHand(Weapon weapon) {
    if (offHand == null) {
      return false;
    }
    return offHand!.contains(weapon.group);
  }

  @override
  String toString() => text;
}

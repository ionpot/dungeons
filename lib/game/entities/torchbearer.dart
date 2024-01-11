import "package:dungeons/game/entity.dart";
import "package:dungeons/game/entity/armor.dart";
import "package:dungeons/game/entity/class.dart";
import "package:dungeons/game/entity/gear.dart";
import "package:dungeons/game/entity/race.dart";
import "package:dungeons/game/entity/weapon.dart";
import "package:dungeons/utility/dice.dart";

Entity rollTorchbearer() {
  final entity = Entity(
    name: "Torchbearer",
    race: EntityRace.human,
  )..klass = EntityClass.warrior;

  int d6() => const Dice(1, 6).roll().total;
  entity.base
    ..strength = 7 + d6()
    ..agility = 7 + d6()
    ..intellect = 7 + d6();

  entity.gear = Gear(
    body: Armor.leather,
    mainHand: Weapon.dagger,
    offHand: Weapon.torch,
  );

  return entity..addXp(-6);
}

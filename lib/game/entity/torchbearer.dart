import "package:dungeons/game/armor.dart";
import "package:dungeons/game/entity.dart";
import "package:dungeons/game/entity_class.dart";
import "package:dungeons/game/entity_race.dart";
import "package:dungeons/game/gear.dart";
import "package:dungeons/game/weapon.dart";
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
  );

  return entity..addXp(-6);
}

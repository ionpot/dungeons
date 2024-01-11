import "dart:math";

import "package:dungeons/game/combat/chance_roll.dart";
import "package:dungeons/game/entity.dart";
import "package:dungeons/game/entity/armor.dart";
import "package:dungeons/game/entity/class.dart";
import "package:dungeons/game/entity/gear.dart";
import "package:dungeons/game/entity/party.dart";
import "package:dungeons/game/entity/race.dart";
import "package:dungeons/game/entity/weapon.dart";
import "package:dungeons/utility/dice.dart";
import "package:dungeons/utility/monoids.dart";

Entity rollOrc(String name, int level) {
  if (level < 1) {
    throw ArgumentError.value(level, "level", "Orc level must be 1 or higher.");
  }
  final entity = Entity(
    name: name,
    race: EntityRace.orc,
  )..klass = EntityClass.monster;

  int d6() => const Dice(1, 6).roll().total;
  entity.base
    ..strength = 9 + d6()
    ..agility = 7 + d6()
    ..intellect = 5 + d6();

  final mainHand = _chance(const Percent(50)) ? Weapon.mace : Weapon.longsword;
  final shield = _chance(const Percent(33));
  entity.gear = Gear(
    body: Armor.leather,
    mainHand: mainHand,
    offHand: shield ? Weapon.shield : null,
  );

  return entity
    ..levelUpTo(level)
    ..spendAllPoints();
}

Party rollOrcParty(int playerLevel) {
  if (playerLevel < 1) {
    throw ArgumentError.value(
      playerLevel,
      "playerLevel",
      "Player level must be 1 or higher.",
    );
  }
  final names = ["Cork", "Dork", "Fork"]..shuffle();
  final sameLevel = playerLevel == 1 ? true : _chance(const Percent(34));
  final single = sameLevel ? true : _chance(const Percent(50));

  int level() {
    final i = Random().nextInt(2);
    final lv = sameLevel ? playerLevel + i : playerLevel - 1 - i;
    return max(1, lv);
  }

  if (single) {
    return Party.single(rollOrc(names.first, level()));
  }
  final slots = List.of(PartySlot.values)..shuffle();
  return Party({
    PartyPosition(PartyLine.front, slots.first): rollOrc(names.first, level()),
    PartyPosition(PartyLine.front, slots.last): rollOrc(names.last, level()),
  });
}

bool _chance(Percent percent) => ChanceRoll().meets(percent);

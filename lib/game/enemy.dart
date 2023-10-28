import 'package:dungeons/game/armor.dart';
import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/entity_class.dart';
import 'package:dungeons/game/entity_race.dart';
import 'package:dungeons/game/gear.dart';
import 'package:dungeons/game/party.dart';
import 'package:dungeons/game/weapon.dart';
import 'package:dungeons/utility/deviate.dart';
import 'package:dungeons/utility/dice.dart';
import 'package:dungeons/utility/percent.dart';

Entity enemyOrc(String name, int level) {
  if (level < 1) {
    throw ArgumentError.value(level, 'level', 'Orc level must be 1 or higher.');
  }
  final entity = Entity(
    name: name,
    race: EntityRace.orc,
    infiniteStress: true,
  )..klass = EntityClass.warrior;

  int d6() => const Dice(1, 6).roll().total;
  entity.base
    ..strength = 9 + d6()
    ..agility = 7 + d6()
    ..intellect = 5 + d6();

  final mainHand = _chance(const Percent(50)) ? Weapon.mace : Weapon.longsword;
  final shield = mainHand.canOneHand && _chance(const Percent(33));
  entity.gear = Gear(
    body: Armor.leather,
    mainHand: mainHand,
    offHand: shield ? Weapon.shield : null,
  );

  return entity
    ..levelUpTo(level)
    ..spendAllPoints();
}

Party enemyOrcParty(int playerLevel) {
  if (playerLevel < 1) {
    throw ArgumentError.value(
      playerLevel,
      'playerLevel',
      'Player level must be 1 or higher.',
    );
  }
  final sameLevel = playerLevel == 1 ? true : _chance(const Percent(34));
  final single = sameLevel ? true : _chance(const Percent(50));
  int level() => sameLevel
      ? playerLevel
      : const Deviate(1, 0).from(playerLevel - 1).withMin(1).roll();
  if (single) {
    return Party.single(enemyOrc('Enemy', level()));
  }
  return Party({
    const PartyPosition(PartyLine.front, PartySlot.left): enemyOrc('Enemy 1', level()),
    const PartyPosition(PartyLine.front, PartySlot.right): enemyOrc('Enemy 2', level()),
  });
}

bool _chance(Percent percent) => percent.roll().success;

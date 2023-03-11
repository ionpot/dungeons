import 'package:dungeons/game/armor.dart';
import 'package:dungeons/game/combat.dart';
import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/entity_class.dart';
import 'package:dungeons/game/entity_race.dart';
import 'package:dungeons/game/gear.dart';
import 'package:dungeons/game/log.dart';
import 'package:dungeons/game/weapon.dart';
import 'package:dungeons/utility/value_callback.dart';
import 'package:dungeons/widget/combat_screen.dart';
import 'package:flutter/widgets.dart';

class Screens {
  final Log log;
  final ValueCallback<Widget> onNext;

  const Screens({required this.log, required this.onNext});

  Entity get pregen {
    return Entity(name: 'Player', race: EntityRace.human, player: true)
      ..base.roll()
      ..klass = EntityClass.cleric
      ..levelUpTo(4)
      ..equip(Gear(mainHand: Weapon.longsword, body: Armor.leather));
  }

  Widget get first => _combatScreen(pregen);

  Widget _combatScreen(Entity player) {
    return CombatScreen(
      Combat.withPlayer(player),
      key: UniqueKey(),
      log: log,
      onWin: () => onNext(_combatScreen(player)),
      onLose: () => onNext(first),
    );
  }
}

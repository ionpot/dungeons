import "package:dungeons/character_screen.dart";
import "package:dungeons/combat_screen.dart";
import "package:dungeons/game/combat.dart";
import "package:dungeons/game/entity/party.dart";
import "package:dungeons/game/log.dart";
import "package:dungeons/utility/value_callback.dart";
import "package:flutter/widgets.dart";

class Screens {
  final Log log;
  final ValueCallback<Widget> onNext;

  const Screens({required this.log, required this.onNext});

  Widget get first => _characterScreen();

  Widget _characterScreen() {
    return CharacterScreen(
      onDone: (player) => onNext(_combatScreen(Party.forPlayer(player))),
    );
  }

  Widget _combatScreen(Party player) {
    return CombatScreen(
      Combat.withPlayer(player),
      key: UniqueKey(),
      log: log,
      onWin: () => onNext(_combatScreen(player)),
      onLose: () => onNext(_characterScreen()),
    );
  }
}

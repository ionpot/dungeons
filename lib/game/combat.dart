import "package:dungeons/game/combat/chosen_action.dart";
import "package:dungeons/game/combat/grid.dart";
import "package:dungeons/game/combat/party.dart";
import "package:dungeons/game/combat/state.dart";
import "package:dungeons/game/entities/orc.dart";
import "package:dungeons/game/pick_action.dart";

class Combat {
  final CombatState state;

  const Combat(this.state);

  Combat.fromGrid(CombatGrid grid) : this(CombatState(grid));

  factory Combat.withPlayer(Party player) {
    final grid = CombatGrid(
      player: player..reset(),
      enemy: rollOrcParty(player.highestLevel),
    );
    grid.refreshAuras();
    return Combat.fromGrid(grid);
  }

  GridMember get current => state.current;
  CombatGrid get grid => state.grid;

  PartyXpGain get xpGain => grid.xpGain;

  int get round => state.round;
  int get turn => state.turn;

  bool get isFirstTurn => turn == 1;
  bool get isNewRound => state.played.isEmpty;
  bool get isPlayerTurn => grid.isPlayer(current);

  bool get won => grid.playerWon;
  bool get lost => grid.enemyWon;

  bool isAlly(GridMember member) => current.party == member.party;
  bool isPlayer(GridMember member) => grid.isPlayer(member);

  ChosenAction? randomAction() => pickAction(current, grid);

  void nextTurn() {
    state.nextTurn();
    current.entity.stopDefending();
    grid.refreshAuras();
  }
}

import "package:dungeons/game/combat/action.dart";
import "package:dungeons/game/combat/chosen_action.dart";
import "package:dungeons/game/combat/grid.dart";
import "package:dungeons/game/combat/party.dart";
import "package:dungeons/game/combat/state.dart";
import "package:dungeons/game/entities/orc.dart";
import "package:dungeons/game/entity.dart";
import "package:dungeons/game/entity/grid_range.dart";
import "package:dungeons/utility/monoids.dart";

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

  void nextTurn() {
    state.nextTurn();
    current.entity.stopDefending();
    grid.refreshAuras();
  }

  ChosenAction? randomAction() {
    final targets = grid.listMembersInRange(current, GridRange.melee);
    final target = _pickMeleeTarget(current, targets);
    return target != null ? ChosenAction(UseWeapon(current), target) : null;
  }
}

GridMember? _pickMeleeTarget(GridMember current, Iterable<GridMember> targets) {
  final lowest = targets
      .lowestOf((entity) => Int(entity.hp))
      .lowestOf((entity) => entity.armorValue.total)
      .lowestOf((entity) => entity.dodge.total);
  if (lowest.isEmpty) return null;
  if (lowest.length == 1) return lowest.first;
  return lowest.firstWhere(
    (member) => member.position.isCenter,
    orElse: () {
      return lowest.firstWhere(
        (member) => current.party.isOccupied(member.position),
        orElse: () => lowest.first,
      );
    },
  );
}

extension _GridMembers on Iterable<GridMember> {
  Iterable<GridMember> lowestOf(Monoid Function(Entity) fn) {
    if (length <= 1) return this;
    var found = <GridMember>[first];
    for (final member in skip(1)) {
      final i = fn(member.entity).compareTo(fn(found.first.entity));
      if (i == -1) {
        found = [member];
      } else if (i == 0) {
        found.add(member);
      }
    }
    return found;
  }
}

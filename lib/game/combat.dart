import "package:dungeons/game/combat/action.dart";
import "package:dungeons/game/combat/chosen_action.dart";
import "package:dungeons/game/combat/grid.dart";
import "package:dungeons/game/entities/orc.dart";
import "package:dungeons/game/entity.dart";
import "package:dungeons/game/entity/grid_range.dart";
import "package:dungeons/game/entity/party.dart";
import "package:dungeons/utility/monoids.dart";

class Combat {
  final CombatGrid grid;
  final Set<GridMember> _played = {};
  int _round = 1;
  int _turn = 1;

  Combat(this.grid) {
    grid.refreshAuras();
  }

  factory Combat.withPlayer(Party player) {
    return Combat(
      CombatGrid(
        player: player..reset(),
        enemy: rollOrcParty(player.highestLevel),
      ),
    );
  }

  int compareSpeed(GridMember a, GridMember b) {
    final i = a.entity.compareSpeed(b.entity);
    if (i == 0) {
      return grid.isPlayer(a) ? -1 : 1;
    }
    return i;
  }

  List<GridMember> get alive {
    return <GridMember>[
      for (final member in grid)
        if (member.entity.alive) member,
    ];
  }

  List<GridMember> get turnOrder => alive..sort(compareSpeed);
  List<GridMember> get notPlayed => turnOrder..removeWhere(_played.contains);

  bool get won => grid.playerWon;
  bool get lost => grid.enemyWon;

  bool get newRound => _played.isEmpty;
  int get round => _round;
  int get turn => _turn;

  GridMember get current => notPlayed.first;
  GridMember get next => notPlayed.length > 1 ? notPlayed[1] : turnOrder.first;

  bool get isFirstTurn => _turn == 1;
  bool get isPlayerTurn => grid.isPlayer(current);

  PartyXpGain get xpGain => grid.xpGain;

  bool canTarget(GridMember target, CombatAction action) {
    final inRange = grid.canTarget(
      actor: action.actor,
      target: target,
      range: action.range,
    );
    return inRange && action.canTarget(target);
  }

  bool isAlly(GridMember member) => current.party == member.party;
  bool isPlayer(GridMember member) => member.party == grid.player;

  ChosenAction? randomAction() {
    final targets = grid.listMembersInRange(current, GridRange.melee);
    final target = _pickMeleeTarget(current, targets);
    return target != null ? ChosenAction(UseWeapon(current), target) : null;
  }

  void nextTurn() {
    _turn += 1;
    _played.add(notPlayed.first);
    if (notPlayed.isEmpty) {
      _played.clear();
      ++_round;
    }
    current.entity.stopDefending();
    grid.refreshAuras();
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

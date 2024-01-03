import "package:dungeons/game/chosen_action.dart";
import "package:dungeons/game/combat_action.dart";
import "package:dungeons/game/combat_grid.dart";
import "package:dungeons/game/entity/orc.dart";
import "package:dungeons/game/grid_range.dart";
import "package:dungeons/game/party.dart";

class Combat {
  final CombatGrid grid;
  final Set<GridMember> _played = {};
  int _round = 1;
  int _turn = 1;

  Combat(this.grid);

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
    if (targets.isEmpty) {
      return null;
    }
    final target = _pickMeleeTarget(targets);
    return ChosenAction(UseWeapon(current), target);
  }

  void nextTurn() {
    _turn += 1;
    _played.add(notPlayed.first);
    if (notPlayed.isEmpty) {
      _played.clear();
      ++_round;
    }
  }
}

GridMember _pickMeleeTarget(Iterable<GridMember> targets) {
  var lowestHp = targets.first;
  for (final target in targets) {
    if (target.entity.hp < lowestHp.entity.hp) {
      lowestHp = target;
    }
  }
  return lowestHp;
}

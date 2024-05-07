import "package:dungeons/game/combat/grid.dart";

class CombatState {
  final CombatGrid grid;
  final Set<GridMember> played = {};
  int round = 1;
  int turn = 1;

  CombatState(this.grid);

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
  List<GridMember> get notPlayed => turnOrder..removeWhere(played.contains);

  GridMember get current => notPlayed.first;
  GridMember get next => notPlayed.length > 1 ? notPlayed[1] : turnOrder.first;

  void nextTurn() {
    turn += 1;
    played.add(notPlayed.first);
    if (notPlayed.isEmpty) {
      played.clear();
      ++round;
    }
  }
}

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

  Iterable<GridMember> get alive => grid.where((m) => m.entity.alive);

  List<GridMember> get turnOrder => alive.toList()..sort(compareSpeed);
  Iterable<GridMember> get notPlayed =>
      turnOrder.where((m) => !played.contains(m));

  GridMember get current => notPlayed.first;
  void nextTurn() {
    turn += 1;
    played.add(notPlayed.first);
    if (notPlayed.isEmpty) {
      played.clear();
      ++round;
    }
  }
}

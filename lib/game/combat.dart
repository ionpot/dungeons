import 'package:dungeons/game/attack.dart';
import 'package:dungeons/game/entity.dart';

class Combat {
  final Entity player;
  final Entity enemy;
  late final Entity _first;
  late Entity _current;
  int _round = 1;

  Combat(this.player, this.enemy) {
    _first = _current = player.fasterThan(enemy) ? player : enemy;
  }

  factory Combat.withPlayer(Entity player) {
    player.resetHp();
    player.tryLevelUp();
    return Combat(player, player.rollEnemy());
  }

  bool get ended => player.dead || enemy.dead;

  bool get newRound => _current == _first;
  int get round => _round;
  Entity get turn => _current;

  Attack attack() => Attack(from: _current, target: _other);

  void next() {
    _current = _other;
    if (newRound) ++_round;
  }

  int get xpGain => player.xpGain(enemy);

  Entity get _other => (_current == player) ? enemy : player;
}

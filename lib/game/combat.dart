import 'package:dungeons/game/attack.dart';
import 'package:dungeons/game/entity.dart';

class Combat {
  final Entity player;
  final Entity enemy;
  final Entity first;
  Entity _current;
  int _round = 1;

  Combat(this.player, this.enemy, this.first) : _current = first;

  factory Combat.withPlayer(Entity player) {
    player.resetHp();
    final enemy = player.rollEnemy();
    final first = player.fasterThan(enemy) ? player : enemy;
    return Combat(player, enemy, first);
  }

  bool get ended => player.dead || enemy.dead;

  bool get newRound => _current == first;
  int get round => _round;
  Entity get turn => _current;

  Attack attack() => Attack(from: _current, target: _other);

  void next() {
    _current = _other;
    if (newRound) ++_round;
  }

  void activateSkills() {
    player.activateSkill();
    enemy.activateSkill();
  }

  int get xpGain => player.xpGain(enemy);

  void addXp() {
    player.xp += xpGain;
  }

  Entity get _other => (_current == player) ? enemy : player;
}

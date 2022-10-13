import 'package:dungeons/game/attack.dart';
import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/entity_race.dart';

class Combat {
  final Entity player;
  final Entity enemy = Entity('Enemy', race: orc)..randomize();
  late final Entity _first;
  late Entity _current;
  int _round = 1;

  Combat(this.player) {
    player.resetHp();
    int i = player.compareSpeed(enemy);
    _current = (i < 0) ? enemy : player;
    _first = _current;
  }

  bool get ended => player.isDead() || enemy.isDead();

  bool get newRound => _current == _first;
  int get round => _round;
  Entity get turn => _current;

  Attack attack() => Attack(from: _current, target: _other);

  void next() {
    _current = _other;
    if (newRound) ++_round;
  }

  Entity get _other => (_current == player) ? enemy : player;
}

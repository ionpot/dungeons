import 'package:dungeons/game/attack.dart';
import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/entity_race.dart';

class Combat {
  final Entity player;
  final Entity enemy = Entity('Enemy', race: orc)..randomize();
  late Entity _current;

  Combat(this.player) {
    player.resetHp();
    int i = player.compareSpeed(enemy);
    _current = (i < 0) ? enemy : player;
  }

  bool get ended => player.isDead() || enemy.isDead();

  Entity get turn => _current;

  Attack attack() => Attack(from: _current, target: _other);

  void next() {
    _current = _other;
  }

  Entity get _other => (_current == player) ? enemy : player;
}

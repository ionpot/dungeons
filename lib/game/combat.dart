import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/entity_race.dart';

class Combat {
  final Entity player;
  final Entity enemy = Entity('Enemy', race: orc)..randomize();
  late Entity _current;

  Combat(this.player) {
    int i = player.compareSpeed(enemy);
    _current = (i < 0) ? enemy : player;
  }

  Entity get turn => _current;

  void next() {
    _current = (_current == player) ? enemy : player;
  }
}

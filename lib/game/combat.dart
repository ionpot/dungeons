import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/entity_race.dart';

class Combat {
  final Entity player;
  final Entity enemy = Entity('Enemy', race: orc)..randomize();

  Combat(this.player);
}

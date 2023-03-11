import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/entity_class.dart';
import 'package:dungeons/game/source.dart';

class Smite {
  static const int rolls = 2;
  static const int stressCost = 4;
  static const Source source = Source.radiant;

  static bool possible(Entity entity) {
    return entity.klass == EntityClass.cleric && entity.level >= 5;
  }

  static bool hasStress(Entity entity) {
    return entity.hasStress(stressCost);
  }
}

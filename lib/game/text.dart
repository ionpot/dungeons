import 'package:dungeons/game/entity.dart';

String xpGainText(Entity entity, int xp) {
  return [
    '$entity gains $xp XP',
    if (entity.canLevelUpWith(xp)) ', and levels up',
    '.'
  ].join();
}

import "package:dungeons/game/combat.dart";
import "package:dungeons/game/entity.dart";

String combatTurnTitle(Combat combat) {
  return "Turn ${combat.turn} (Round ${combat.round})";
}

String xpGainText(Entity entity, int xp) {
  return [
    "$entity gains $xp XP",
    if (entity.canLevelUpWith(xp)) ", and levels up",
    ".",
  ].join();
}

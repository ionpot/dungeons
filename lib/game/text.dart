import "package:dungeons/game/chance_roll.dart";
import "package:dungeons/game/combat.dart";
import "package:dungeons/game/entity.dart";
import "package:dungeons/game/status_effect.dart";
import "package:dungeons/utility/monoids.dart";

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

String chanceRollText(
  ChanceRoll roll,
  Percent percent,
  bool critical,
) {
  var text = "";
  if (critical) {
    text = "Critical success!";
  } else if (percent.always) {
    text = "Auto-success";
  } else if (percent.never) {
    text = "Auto-fail";
  } else if (roll.meets(percent)) {
    text = "Success";
  } else {
    text = "Fail";
  }
  return "$roll -> $text";
}

String effectText(StatusEffect effect) {
  switch (effect) {
    case StatusEffect.bless:
      return "is blessed";
    case StatusEffect.defending:
      return "is defending";
    case StatusEffect.frenzy:
      return "is frenzied";
    case StatusEffect.slow:
      return "is slowed";
    case StatusEffect.canFrenzy:
    case StatusEffect.maxDamage:
    case StatusEffect.noStress:
      return "";
  }
}

String offHandText(Entity e) {
  final offHand = e.gear.offHand;
  if (offHand == null) return "None";
  var str = "$offHand";
  final armor = e.gear.shieldArmor;
  final dice = e.gear.offHandValue?.dice;
  if (armor != null) {
    str += " ($armor)";
  } else if (dice != null) {
    str += " ($dice)";
  }
  return str;
}

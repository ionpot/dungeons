import "package:dungeons/game/bonus.dart";
import "package:dungeons/game/bonuses.dart";
import "package:dungeons/game/entity.dart";
import "package:dungeons/game/source.dart";

abstract class ActionParameters {
  const ActionParameters();

  Entity get actor;
  Entity get target;

  int get stressCost => 0;
  Bonus? get reserveStress => null;

  Bonuses get effects => Bonuses();

  Source get source => Source.physical;

  ActionResult toResult();
  ActionResult downcast(ActionResult result);

  void apply(covariant ActionResult result) {
    if (result.didHit) {
      target.takeDamage(result.damageDone);
      target.heal(result.healingDone);
      target.addEffects(effects);
    }
    if (reserveStress != null) {
      actor.reserveStressFor(reserveStress!, stressCost);
    } else {
      actor.addStress(stressCost);
    }
  }
}

abstract class ActionResult {
  const ActionResult();

  bool get didHit => false;
  int get damageDone => 0;
  int get healingDone => 0;
}

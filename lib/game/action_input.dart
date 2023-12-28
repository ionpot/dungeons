import "package:dungeons/game/bonus.dart";
import "package:dungeons/game/entity.dart";
import "package:dungeons/game/source.dart";
import "package:dungeons/game/status_effects.dart";

abstract class ActionInput {
  const ActionInput();

  Entity get actor;
  Entity get target;

  int get stressCost => 0;
  Bonus? get reserveStress => null;

  StatusEffects get effects => const StatusEffects({});

  Source get source => Source.physical;
}

abstract class ActionResult {
  const ActionResult();

  ActionInput get input;

  bool get didHit => false;
  int get damageDone => 0;
  int get healingDone => 0;

  void apply() {
    if (didHit) {
      input.target
        ..takeDamage(damageDone)
        ..heal(healingDone)
        ..effects.addAll(input.effects);
    }
    final ActionInput(:actor, :reserveStress, :stressCost) = input;
    if (!actor.flags.ignoreStress) {
      if (reserveStress != null) {
        actor.reserveStressFor(reserveStress, stressCost);
      } else {
        actor.addStress(stressCost);
      }
    }
  }
}

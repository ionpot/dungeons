import "package:dungeons/game/bonus.dart";
import "package:dungeons/game/entity.dart";
import "package:dungeons/game/source.dart";
import "package:dungeons/game/status_effect.dart";
import "package:dungeons/game/status_effects.dart";

abstract class ActionInput {
  const ActionInput();

  Entity get actor;
  Entity get target;

  int get stressCost => 0;
  Bonus? get reserveStress => null;

  Source get source => Source.physical;
}

abstract class ActionResult {
  const ActionResult();

  ActionInput get input;
  Entity get actor => input.actor;
  Entity get target => input.target;

  bool get didHit => false;
  int get damageDone => 0;
  int get healingDone => 0;

  StatusEffects get inflicted => StatusEffects.empty();

  StatusEffects get effects {
    final extra = StatusEffects.empty();
    if (damageDone > 0) {
      final bonus = target.effects.findBonusOf(StatusEffect.canFrenzy);
      if (bonus != null) {
        extra.add(bonus, StatusEffect.frenzy);
      }
    }
    return inflicted + extra;
  }

  void apply() {
    if (didHit) {
      target
        ..takeDamage(damageDone)
        ..heal(healingDone)
        ..temporary.addAll(effects);
    }
    final ActionInput(:reserveStress, :stressCost) = input;
    if (!actor.ignoreStress) {
      if (reserveStress != null) {
        actor.reserveStressFor(reserveStress, stressCost, target);
      } else {
        actor.addStress(stressCost);
      }
    }
  }
}

import "package:dungeons/game/combat/action_input.dart";
import "package:dungeons/game/entity.dart";
import "package:dungeons/game/entity/bonus.dart";
import "package:dungeons/game/entity/status_effect.dart";
import "package:dungeons/game/entity/status_effects.dart";

class DefendInput extends ActionInput {
  @override
  final Entity actor;

  const DefendInput(this.actor);

  @override
  Entity get target => actor;
}

class DefendResult extends ActionResult {
  @override
  final ActionInput input;

  const DefendResult(this.input);

  @override
  StatusEffects get inflicted {
    return StatusEffects.single(
      OtherBonus.defending,
      StatusEffect.defending,
    );
  }

  @override
  void apply() => actor.temporary.addAll(inflicted);
}

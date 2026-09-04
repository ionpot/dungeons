import "package:dungeons/game/combat/reservation.dart";
import "package:dungeons/game/entity.dart";
import "package:dungeons/game/entity/bonus.dart";
import "package:dungeons/game/entity/status_effects.dart";
import "package:dungeons/game/source.dart";

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

  StatusEffects get effects => inflicted;

  bool get stopDefending => actor.isDefending;

  Iterable<Reservation> get addedReservations {
    final ActionInput(:reserveStress) = input;
    if (reserveStress != null && !actor.ignoreStress) {
      return [Reservation(actor, target, reserveStress)];
    }
    return const [];
  }

  int get stressDone => addedReservations.isEmpty ? input.stressCost : 0;
  int get reservedStressDone =>
      addedReservations.isNotEmpty ? input.stressCost : 0;

  Iterable<Reservation> removedReservations(Iterable<Reservation> current) {
    final willDie = didHit && target.hp + healingDone - damageDone <= 0;
    return current.where((r) => r.target == target && willDie);
  }
}

import "package:dungeons/game/combat/party.dart";
import "package:dungeons/game/combat/reservation.dart";
import "package:dungeons/game/entity.dart";
import "package:dungeons/game/entity/aura.dart";

sealed class CombatEvent {
  const CombatEvent();
}

class AurasApplied extends CombatEvent {
  final Party party;
  final Aura aura;

  const AurasApplied(this.party, this.aura);
}

class EntityDied extends CombatEvent {
  final Entity entity;
  final List<Reservation> removedReservations;
  final Aura? removedAura;

  const EntityDied({
    required this.entity,
    required this.removedReservations,
    required this.removedAura,
  });
}

class FrenzyTriggered extends CombatEvent {
  final Entity entity;

  const FrenzyTriggered(this.entity);
}

import "package:dungeons/game/combat/action_input.dart";
import "package:dungeons/game/combat/chosen_action.dart";
import "package:dungeons/game/combat/event.dart";
import "package:dungeons/game/combat/grid.dart";
import "package:dungeons/game/combat/party.dart";
import "package:dungeons/game/combat/state.dart";
import "package:dungeons/game/entities/orc.dart";
import "package:dungeons/game/entity/status_effect.dart";
import "package:dungeons/game/pick_action.dart";

class Combat {
  final CombatState state;

  const Combat(this.state);

  Combat.fromGrid(CombatGrid grid) : this(CombatState(grid));

  factory Combat.withPlayer(Party player) {
    final grid = CombatGrid(
      player: player..reset(),
      enemy: rollOrcParty(player.highestLevel),
    );
    return Combat.fromGrid(grid);
  }

  GridMember get current => state.current;
  CombatGrid get grid => state.grid;

  PartyXpGain get xpGain => grid.xpGain;

  int get round => state.round;
  int get turn => state.turn;

  bool get isNewRound => state.played.isEmpty;
  bool get isPlayerTurn => grid.isPlayer(current);

  bool get won => grid.playerWon;
  bool get lost => grid.enemyWon;

  bool isAlly(GridMember member) => current.party == member.party;
  bool isPlayer(GridMember member) => grid.isPlayer(member);

  ChosenAction randomAction() => pickAction(current, grid);

  Iterable<CombatEvent> start() {
    final events = <CombatEvent>[];
    for (final member in grid) {
      final aura = member.entity.aura;
      if (aura != null) {
        final targetParty = grid.partyForRange(member.party, aura.range);
        events.add(AurasApplied(targetParty, aura));
      }
    }
    return events;
  }

  Iterable<CombatEvent> applyAction(ActionResult result) {
    if (result.stopDefending) {
      result.actor.stopDefending();
    }
    if (result.didHit) {
      result.target
        ..takeDamage(result.damageDone)
        ..heal(result.healingDone)
        ..temporary.addAll(result.effects);
    }
    if (!result.actor.ignoreStress) {
      final added = result.addedReservations;
      if (added.isNotEmpty) {
        for (final r in added) {
          result.actor.addReservedStress(r.bonus, result.reservedStressDone);
        }
        state.reservations.addAll(added);
      } else {
        result.actor.addStress(result.stressDone);
      }
    }
    final removed = result.removedReservations(state.reservations);

    final events = <CombatEvent>[];
    if (result.target.dead) {
      events.add(
        EntityDied(
          entity: result.target,
          removedReservations: removed.toList(),
          removedAura: result.target.aura,
        ),
      );
    }
    if (result.damageDone > 0 &&
        result.target.hasBonus(StatusEffect.canFrenzy)) {
      events.add(FrenzyTriggered(result.target));
    }
    return events;
  }

  void applyEvent(CombatEvent event) {
    switch (event) {
      case AurasApplied e:
        e.party.addAuraEffect(e.aura);
      case EntityDied e:
        for (final r in e.removedReservations) {
          r.actor.removeReservedStress(r.bonus);
        }
        state.reservations.removeWhere(e.removedReservations.contains);
        if (e.removedAura != null) {
          final member = grid.find(e.entity);
          if (member != null) {
            final targetParty =
                grid.partyForRange(member.party, e.removedAura!.range);
            targetParty.removeAuraEffect(e.removedAura!);
          }
        }
      case FrenzyTriggered e:
        final bonus = e.entity.effects.findBonusOf(StatusEffect.canFrenzy);
        if (bonus != null) {
          e.entity.temporary.add(bonus, StatusEffect.frenzy);
        }
    }
  }

  void nextTurn() {
    state.nextTurn();
  }
}

import "package:dungeons/game/entity.dart";
import "package:dungeons/game/entity/grid_range.dart";
import "package:dungeons/game/combat/party.dart";

class GridMember extends PartyMember {
  final Party party;

  GridMember(this.party, PartyMember member)
      : super(
          member.position,
          member.entity,
        );

  bool isAllyOf(GridMember member) => party == member.party;

  @override
  int get hashCode => Object.hash(party, super.hashCode);

  @override
  bool operator ==(Object other) {
    return hashCode == other.hashCode;
  }
}

class CombatGrid extends Iterable<GridMember> {
  final Party player;
  final Party enemy;

  const CombatGrid({required this.player, required this.enemy});

  Iterable<GridMember> membersOf(Party party) {
    return party.map((member) => GridMember(party, member));
  }

  bool get playerWon => player.isAlive && enemy.isDead;
  bool get enemyWon => player.isDead && enemy.isAlive;

  PartyXpGain get xpGain {
    return PartyXpGain(won: player, lost: enemy);
  }

  Party otherParty(Party party) {
    return party == player ? enemy : player;
  }

  bool isPlayer(GridMember member) => member.party == player;

  GridMember? find(Entity entity) {
    for (final member in this) {
      if (member.entity == entity) {
        return member;
      }
    }
    return null;
  }

  bool canTarget({
    required GridMember actor,
    required GridMember target,
    GridRange? range,
  }) {
    return listMembersInRange(actor, range).contains(target);
  }

  Iterable<GridMember> listMembersInRange(GridMember actor, GridRange? range) {
    final party = _rangeToParty(range, actor.party);
    return _listMembersInRange(actor, range)
        .map((member) => GridMember(party, member));
  }

  Iterable<PartyMember> _listMembersInRange(
    GridMember actor,
    GridRange? range,
  ) {
    if (range == null) {
      return [actor];
    }
    final party = actor.party;
    switch (range.slot) {
      case SlotRange.adjacent:
        switch (range.party) {
          case PartyRange.ally:
            return party.adjacentAllies(actor.position);
          case PartyRange.enemy:
            if (party.canMeleeEnemy(actor.position)) {
              return otherParty(party).adjacentEnemies(actor.position);
            }
            return [];
        }
      case SlotRange.any:
        switch (range.party) {
          case PartyRange.ally:
            return party.aliveMembers;
          case PartyRange.enemy:
            return otherParty(party).aliveMembers;
        }
    }
  }

  Party _rangeToParty(GridRange? range, Party party) {
    switch (range?.party) {
      case PartyRange.ally:
      case null:
        return party;
      case PartyRange.enemy:
        return otherParty(party);
    }
  }

  void refreshAuras() {
    player.clearAuraEffects();
    enemy.clearAuraEffects();
    _addAurasFrom(player);
    _addAurasFrom(enemy);
  }

  void _addAurasFrom(Party party) {
    for (final PartyMember(:entity) in party.alive) {
      final Entity(:aura) = entity;
      if (aura != null) {
        switch (aura.range) {
          case PartyRange.ally:
            party.addAuraEffect(aura);
            break;
          case PartyRange.enemy:
            otherParty(party).addAuraEffect(aura);
            break;
        }
      }
    }
  }

  @override
  Iterator<GridMember> get iterator {
    return membersOf(player).followedBy(membersOf(enemy)).iterator;
  }
}

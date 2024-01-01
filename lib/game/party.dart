import "dart:math";

import "package:dungeons/game/entity.dart";
import "package:dungeons/game/entity/torchbearer.dart";
import "package:dungeons/game/entity_class.dart";

enum PartyLine { front, back }

enum PartySlot {
  left,
  center,
  right;

  PartySlot get opposite {
    switch (this) {
      case left:
        return right;
      case center:
        return center;
      case right:
        return left;
    }
  }
}

class PartyPosition {
  final PartyLine line;
  final PartySlot slot;

  const PartyPosition(this.line, this.slot);

  bool get isCenter => slot == PartySlot.center;

  @override
  int get hashCode => Object.hash(line, slot);

  @override
  bool operator ==(Object other) {
    return hashCode == other.hashCode;
  }
}

class PartyMember {
  final PartyPosition position;
  final Entity entity;

  const PartyMember(this.position, this.entity);

  @override
  int get hashCode => Object.hash(position, entity);

  @override
  bool operator ==(Object other) {
    return hashCode == other.hashCode;
  }

  @override
  String toString() => entity.toString();
}

class PartyMemberIterator implements Iterator<PartyMember> {
  final Iterator<MapEntry<PartyPosition, Entity>> iterator;

  PartyMemberIterator(this.iterator);

  @override
  PartyMember get current =>
      PartyMember(iterator.current.key, iterator.current.value);

  @override
  bool moveNext() => iterator.moveNext();
}

class Party extends Iterable<PartyMember> {
  final Map<PartyPosition, Entity> members;

  const Party(this.members);
  Party.copy(Party party) : this(Map.of(party.members));

  factory Party.single(Entity entity) {
    return Party({
      const PartyPosition(PartyLine.front, PartySlot.center): entity,
    });
  }

  factory Party.forPlayer(Entity player) {
    final playerLine =
        player.klass == EntityClass.mage ? PartyLine.back : PartyLine.front;
    var playerSlot = PartySlot.center;
    var followerSlot = PartySlot.center;
    if (playerLine == PartyLine.front) {
      final slots = List.of(PartySlot.values)..shuffle();
      playerSlot = slots.first;
      followerSlot = slots.last;
    }
    return Party({
      PartyPosition(playerLine, playerSlot): player,
      PartyPosition(PartyLine.front, followerSlot): rollTorchbearer(),
    });
  }

  Party get alive =>
      Party.copy(this)..members.removeWhere((_, member) => member.dead);

  Iterable<PartyMember> get aliveMembers {
    return where((member) => member.entity.alive);
  }

  bool get isAlive => aliveMembers.isNotEmpty;
  bool get isDead => aliveMembers.isEmpty;

  PartyMember? findMember(Entity entity) {
    for (final member in this) {
      if (member.entity == entity) {
        return member;
      }
    }
    return null;
  }

  int get highestLevel =>
      fold(0, (highest, member) => max(highest, member.entity.level));

  PartyMember get highestLevelMember =>
      firstWhere((member) => member.entity.level == highestLevel);

  bool lineOccupied(PartyLine line) {
    for (final member in this) {
      if (member.position.line == line) {
        if (member.entity.alive) {
          return true;
        }
      }
    }
    return false;
  }

  PartyLine? get meleeLine {
    for (final line in PartyLine.values) {
      if (lineOccupied(line)) {
        return line;
      }
    }
    return null;
  }

  bool canMeleeEnemy(PartyPosition position) {
    if (position.line == PartyLine.back) {
      if (lineOccupied(PartyLine.front)) {
        return false;
      }
    }
    return true;
  }

  List<PartyMember> membersInLine(PartyLine line) {
    return [
      for (final member in this)
        if (member.entity.alive)
          if (member.position.line == line) member,
    ];
  }

  List<PartyMember> adjacentAllies(PartyPosition position) {
    return [];
  }

  List<PartyMember> adjacentEnemies(PartyPosition position) {
    final line = meleeLine;
    if (line == null) {
      return [];
    }
    final members = membersInLine(line);
    if (position.isCenter) {
      return members;
    }
    if (members.length > 1) {
      members.removeWhere(
        (member) => member.position.slot == position.slot.opposite,
      );
    }
    return members;
  }

  void reset() {
    for (final PartyMember(:entity) in this) {
      entity
        ..resetHp()
        ..clearStress()
        ..temporary.clear();
    }
  }

  @override
  Iterator<PartyMember> get iterator =>
      PartyMemberIterator(members.entries.iterator);
}

class PartyXpGain extends Iterable<PartyMember> {
  final Party won;
  final Party lost;

  const PartyXpGain({required this.won, required this.lost});

  bool get canLevelUp {
    return any((member) {
      return member.entity.canLevelUpWith(amount);
    });
  }

  int get amount {
    final highest = won.alive.highestLevelMember.entity;
    return lost.fold(
      0,
      (total, other) => total + highest.xpGain(other.entity),
    );
  }

  void apply() {
    final xp = amount;
    for (final member in this) {
      member.entity.addXp(xp);
    }
  }

  @override
  Iterator<PartyMember> get iterator {
    return won.aliveMembers.iterator;
  }
}

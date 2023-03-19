import 'dart:math';

import 'package:dungeons/game/entity.dart';

enum PartyLine { front, back }

enum PartySlot { left, center, right }

class PartyPosition {
  final PartyLine line;
  final PartySlot slot;

  const PartyPosition(this.line, this.slot);

  @override
  int get hashCode => Object.hash(line, slot);

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;
}

class Party {
  final Map<PartyPosition, Entity> members;

  const Party(this.members);

  factory Party.single(Entity entity) {
    return Party({
      const PartyPosition(PartyLine.front, PartySlot.center): entity,
    });
  }

  Iterable<Entity> get list => members.values;

  bool get isAlive => list.any((entity) => entity.alive);
  bool get isDead => list.every((entity) => entity.dead);

  bool hasEntity(Entity entity) => list.contains(entity);

  int get highestLevel =>
      list.fold(0, (highest, entity) => max(highest, entity.level));

  Entity get highestLeveled =>
      list.firstWhere((entity) => entity.level == highestLevel);

  Entity? get hasExtraPoints {
    for (final entity in list) {
      if (entity.extraPoints > 0) {
        return entity;
      }
    }
    return null;
  }

  PartyXpGain xpGain(Party other) {
    return PartyXpGain({
      for (final entity in list)
        if (entity.alive) entity: entity.xpGain(other.highestLeveled),
    });
  }
}

class PartyXpGain {
  final Map<Entity, int> map;

  const PartyXpGain(this.map);

  bool get canLevelUp =>
      map.entries.any((entry) => entry.key.canLevelUpWith(entry.value));

  void apply() {
    for (final entry in map.entries) {
      entry.key.xp += entry.value;
      entry.key.tryLevelUp();
    }
  }
}

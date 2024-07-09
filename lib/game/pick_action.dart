import "package:dungeons/game/combat/action.dart";
import "package:dungeons/game/combat/chosen_action.dart";
import "package:dungeons/game/combat/grid.dart";
import "package:dungeons/game/entity.dart";
import "package:dungeons/game/entity/grid_range.dart";
import "package:dungeons/utility/monoids.dart";

ChosenAction? pickAction(GridMember member, CombatGrid grid) {
  final targets = grid.listMembersInRange(member, GridRange.melee);
  final target = _pickMeleeTarget(member, targets);
  return target != null ? ChosenAction(UseWeapon(member), target) : null;
}

GridMember? _pickMeleeTarget(GridMember current, Iterable<GridMember> targets) {
  final lowest = targets
      .lowestOf((entity) => Int(entity.hp))
      .lowestOf((entity) => entity.armorValue.total)
      .lowestOf((entity) => entity.dodge.total);
  if (lowest.isEmpty) return null;
  if (lowest.length == 1) return lowest.first;
  return lowest.firstWhere(
    (member) => member.position.isCenter,
    orElse: () {
      return lowest.firstWhere(
        (member) => current.party.isOccupied(member.position),
        orElse: () => lowest.first,
      );
    },
  );
}

extension _GridMembers on Iterable<GridMember> {
  Iterable<GridMember> lowestOf(Monoid Function(Entity) fn) {
    if (length <= 1) return this;
    var found = <GridMember>[first];
    for (final member in skip(1)) {
      final i = fn(member.entity).compareTo(fn(found.first.entity));
      if (i == -1) {
        found = [member];
      } else if (i == 0) {
        found.add(member);
      }
    }
    return found;
  }
}

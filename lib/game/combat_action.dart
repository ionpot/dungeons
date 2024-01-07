import "package:dungeons/game/action_input.dart";
import "package:dungeons/game/combat_grid.dart";
import "package:dungeons/game/defend.dart";
import "package:dungeons/game/entity_class.dart";
import "package:dungeons/game/grid_range.dart";
import "package:dungeons/game/rapid_shot.dart";
import "package:dungeons/game/smite.dart";
import "package:dungeons/game/source.dart";
import "package:dungeons/game/spell.dart";
import "package:dungeons/game/spell_cast.dart";
import "package:dungeons/game/two_weapon_attack.dart";
import "package:dungeons/game/weapon_attack.dart";

sealed class CombatAction {
  final GridMember actor;

  const CombatAction(this.actor);

  bool get canUse;
  bool get hasResources;

  bool canTarget(GridMember target) => true;

  ActionInput input(GridMember target);
  ActionResult result(covariant ActionInput input);

  GridRange? get range => GridRange.melee;
  Source get source => Source.physical;
}

final class UseWeapon extends CombatAction {
  const UseWeapon(super.actor);

  @override
  bool get canUse => actor.entity.gear.mainHand != null;

  @override
  bool get hasResources => true;

  @override
  WeaponAttackInput input(GridMember target) {
    return WeaponAttackInput(
      actor: actor.entity,
      target: target.entity,
    );
  }

  @override
  WeaponAttackResult result(WeaponAttackInput input) {
    return WeaponAttackResult(input, input.roll());
  }

  @override
  GridRange? get range {
    return actor.entity.gear.usingBow ? GridRange.any : GridRange.melee;
  }
}

final class UseTwoWeapons extends CombatAction {
  const UseTwoWeapons(super.actor);

  @override
  bool get hasResources {
    return actor.entity.hasStress(TwoWeaponAttack.stressCost);
  }

  @override
  bool get canUse => actor.entity.gear.hasTwoWeapons;

  @override
  TwoWeaponAttackInput input(GridMember target) {
    return TwoWeaponAttackInput(
      actor: actor.entity,
      target: target.entity,
    );
  }

  @override
  TwoWeaponAttackResult result(TwoWeaponAttackInput input) {
    return TwoWeaponAttackResult(input, input.roll());
  }
}

final class UseSmite extends CombatAction {
  const UseSmite(super.actor);

  @override
  bool get canUse {
    final cleric = actor.entity.klass == EntityClass.cleric;
    final level5 = actor.entity.level >= 5;
    return cleric && level5;
  }

  @override
  bool get hasResources => actor.entity.hasStress(Smite.stressCost);

  @override
  SmiteInput input(GridMember target) {
    return SmiteInput(
      actor: actor.entity,
      target: target.entity,
    );
  }

  @override
  Source get source => Smite.source;

  @override
  SmiteResult result(SmiteInput input) {
    return SmiteResult(input, input.roll());
  }
}

final class CastSpell extends CombatAction {
  final Spell spell;

  const CastSpell(super.actor, this.spell);

  @override
  bool get canUse => actor.entity.knownSpells.contains(spell);

  @override
  bool get hasResources => actor.entity.canCast(spell);

  @override
  bool canTarget(GridMember target) {
    return input(target).canEffect;
  }

  @override
  SpellCastInput input(GridMember target) {
    return SpellCastInput(
      spell,
      caster: actor.entity,
      target: target.entity,
    );
  }

  @override
  SpellCastResult result(SpellCastInput input) {
    return SpellCastResult.from(input, input.roll());
  }

  @override
  GridRange? get range => spell.range;

  @override
  Source get source => spell.source;
}

final class UseRapidShot extends CombatAction {
  const UseRapidShot(super.actor);

  @override
  bool get hasResources {
    return actor.entity.hasStress(RapidShot.stressCost);
  }

  @override
  bool get canUse => actor.entity.gear.usingBow;

  @override
  GridRange? get range => GridRange.any;

  @override
  RapidShotInput input(GridMember target) {
    return RapidShotInput(
      actor: actor.entity,
      target: target.entity,
    );
  }

  @override
  RapidShotResult result(RapidShotInput input) {
    return RapidShotResult(input, input.roll());
  }
}

final class Defend extends CombatAction {
  const Defend(super.actor);

  @override
  bool get canUse => true;

  @override
  bool get hasResources => true;

  @override
  GridRange? get range => null;

  @override
  ActionInput input(GridMember target) {
    return DefendInput(target.entity);
  }

  @override
  ActionResult result(DefendInput input) {
    return DefendResult(input);
  }
}

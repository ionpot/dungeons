import "package:dungeons/game/bonus.dart";
import "package:dungeons/game/bonuses.dart";
import "package:dungeons/game/combat_grid.dart";
import "package:dungeons/game/entity.dart";
import "package:dungeons/game/entity_class.dart";
import "package:dungeons/game/grid_range.dart";
import "package:dungeons/game/source.dart";
import "package:dungeons/game/spell.dart";
import "package:dungeons/game/spell_cast.dart";
import "package:dungeons/game/weapon_attack.dart";

sealed class CombatAction {
  final GridMember actor;

  const CombatAction(this.actor);

  bool get canUse;
  bool get hasResources;
  ActionParameters parameters(GridMember target);

  GridRange? get range => GridRange.melee;
  Source get source => Source.physical;
}

abstract class ActionParameters {
  const ActionParameters();

  Entity get actor;
  Entity get target;

  int get stressCost => 0;
  Bonus? get reserveStress => null;

  Bonuses get effects => Bonuses();

  Source get source => Source.physical;

  ActionResult toResult();
  ActionResult downcast(ActionResult result);

  void apply(covariant ActionResult result) {
    if (result.didHit) {
      target.takeDamage(result.damageDone);
      target.heal(result.healingDone);
      target.addEffects(effects);
    }
    if (reserveStress != null) {
      actor.reserveStressFor(reserveStress!, stressCost);
    } else {
      actor.addStress(stressCost);
    }
  }
}

abstract class ActionResult {
  const ActionResult();

  bool get didHit => false;
  int get damageDone => 0;
  int get healingDone => 0;
}

final class UseWeapon extends CombatAction {
  const UseWeapon(super.actor);

  @override
  bool get canUse => actor.entity.gear.mainHand != null;

  @override
  bool get hasResources => true;

  @override
  ActionParameters parameters(GridMember target) {
    return WeaponAttack(
      attacker: actor.entity,
      target: target.entity,
    );
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
  ActionParameters parameters(GridMember target) {
    return WeaponAttack(
      attacker: actor.entity,
      target: target.entity,
      useOffHand: true,
    );
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
  ActionParameters parameters(GridMember target) {
    return WeaponAttack(
      attacker: actor.entity,
      target: target.entity,
      smite: true,
    );
  }

  @override
  Source get source => Smite.source;
}

final class CastSpell extends CombatAction {
  final Spell spell;

  const CastSpell(super.actor, this.spell);

  @override
  bool get canUse => actor.entity.knownSpells.contains(spell);

  @override
  bool get hasResources => actor.entity.canCast(spell);

  @override
  ActionParameters parameters(GridMember target) {
    return SpellCast(
      spell,
      caster: actor.entity,
      target: target.entity,
    );
  }

  @override
  GridRange? get range => spell.range;

  @override
  Source get source => spell.source;
}

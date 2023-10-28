import 'package:dungeons/game/combat_grid.dart';
import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/entity_class.dart';
import 'package:dungeons/game/grid_range.dart';
import 'package:dungeons/game/smite.dart';
import 'package:dungeons/game/source.dart';
import 'package:dungeons/game/spell.dart';
import 'package:dungeons/game/spell_cast.dart';
import 'package:dungeons/game/weapon_attack.dart';

abstract class CombatAction {
  final GridMember actor;

  const CombatAction(this.actor);

  bool get canUse;
  bool get hasResources;
  ActionParameters parameters(GridMember target);

  GridRange? get range => GridRange.melee;
  Source get source => Source.physical;
}

abstract class ActionParameters {
  Entity get actor;
  Entity get target;

  ActionResult toResult();
  ActionResult downcast(ActionResult result);

  void apply(covariant ActionResult result);
}

abstract class ActionResult {
  bool get isSlowed => false; // <-- will be a StatusEffect enum
}

class ChosenAction {
  final CombatAction action;
  final GridMember target;

  const ChosenAction(this.action, this.target);

  ActionParameters get parameters => action.parameters(target);

  ActionResult toResult() => parameters.toResult();

  void apply(ActionResult result) {
    parameters.apply(result);
  }
}

class UseWeapon extends CombatAction {
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

class UseTwoWeapons extends CombatAction {
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

class UseSmite extends CombatAction {
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

class CastSpell extends CombatAction {
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

import 'package:dungeons/game/bonus.dart';
import 'package:dungeons/game/combat_action.dart';
import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/source.dart';
import 'package:dungeons/game/spell.dart';
import 'package:dungeons/game/value.dart';
import 'package:dungeons/utility/dice.dart';
import 'package:dungeons/utility/if.dart';

class SpellCast implements ActionParameters {
  final Spell spell;
  final Entity caster;
  @override
  final Entity target;

  const SpellCast(this.spell, {required this.caster, required this.target});

  @override
  Entity get actor => caster;

  bool get self => caster == target;

  PercentValue get resistChance =>
      spell.autoHit ? const PercentValue() : target.resist;

  Source get source => spell.source;

  @override
  SpellCastResult toResult() {
    return SpellCastResult(
      autoHit: spell.autoHit,
      canEffect: target.canSpellEffect(spell),
      resistRoll: resistChance.roll(),
      targetSelf: self,
      slows: spell.slows,
      damageRoll: _roll(spell.damage),
      healRoll: _roll(spell.heals),
    );
  }

  @override
  SpellCastResult downcast(ActionResult result) {
    if (result is SpellCastResult) {
      return result;
    }
    throw ArgumentError.value(result, "result");
  }

  @override
  void apply(SpellCastResult result) {
    if (spell.reserveStress) {
      caster.reserveStressFor(SpellBonus(spell), spell.stress);
    } else {
      caster.addStress(spell.stress);
    }
    ifdef(result.healDone, target.heal);
    ifdef(result.damageDone, target.takeDamage);
    if (result.didEffect) {
      target.addSpellBonus(spell);
    }
  }

  DiceRollValue? _roll(Dice? dice) {
    return ifdef(dice, DiceRollValue.roll);
  }
}

class SpellCastResult implements ActionResult {
  final bool autoHit;
  final bool canEffect;
  final PercentValueRoll resistRoll;
  final bool targetSelf;
  final bool slows;
  final DiceRollValue? damageRoll;
  final DiceRollValue? healRoll;

  const SpellCastResult({
    required this.autoHit,
    required this.canEffect,
    required this.resistRoll,
    required this.targetSelf,
    required this.slows,
    this.damageRoll,
    this.healRoll,
  });

  bool get canResist => !targetSelf && !autoHit;
  bool get didEffect => targetSelf ? canEffect : didHit && canEffect;
  bool get didHit => !canResist || resistRoll.fail;
  bool get resisted => !didHit;

  int? get damageDone => didHit ? damageRoll?.total : null;
  int? get healDone => didHit ? healRoll?.total : null;

  @override
  bool get isSlowed => didEffect && slows;
}

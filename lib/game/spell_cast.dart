import "package:dungeons/game/action_parameters.dart";
import "package:dungeons/game/bonus.dart";
import "package:dungeons/game/bonuses.dart";
import "package:dungeons/game/entity.dart";
import "package:dungeons/game/source.dart";
import "package:dungeons/game/spell.dart";
import "package:dungeons/game/value.dart";
import "package:dungeons/utility/dice.dart";
import "package:dungeons/utility/if.dart";

class SpellCast extends ActionParameters {
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

  @override
  Source get source => spell.source;

  @override
  int get stressCost => spell.stress;

  @override
  Bonus? get reserveStress {
    if (spell.reserveStress) {
      return SpellBonus(spell);
    }
    return null;
  }

  @override
  Bonuses get effects {
    final effects = Bonuses();
    if (spell.effect != null) {
      final bonus = SpellBonus(spell);
      if (spell.stacks || !target.hasBonus(bonus)) {
        effects.add(bonus, spell.effect);
      }
    }
    return effects;
  }

  @override
  SpellCastResult toResult() {
    return SpellCastResult(
      autoHit: spell.autoHit,
      resistRoll: resistChance.roll(),
      targetSelf: self,
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

  DiceRollValue? _roll(Dice? dice) {
    return ifdef(dice, DiceRollValue.roll);
  }
}

class SpellCastResult extends ActionResult {
  final bool autoHit;
  final PercentValueRoll resistRoll;
  final bool targetSelf;
  final DiceRollValue? damageRoll;
  final DiceRollValue? healRoll;

  const SpellCastResult({
    required this.autoHit,
    required this.resistRoll,
    required this.targetSelf,
    this.damageRoll,
    this.healRoll,
  });

  bool get canResist => !targetSelf && !autoHit;
  @override
  bool get didHit => !canResist || resistRoll.fail;
  bool get resisted => !didHit;
  @override
  int get damageDone => damageRoll?.total ?? 0;
  @override
  int get healingDone => healRoll?.total ?? 0;
}

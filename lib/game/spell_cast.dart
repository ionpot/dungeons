import "package:dungeons/game/action_input.dart";
import "package:dungeons/game/bonus.dart";
import "package:dungeons/game/bonus_entry.dart";
import "package:dungeons/game/chance_roll.dart";
import "package:dungeons/game/entity.dart";
import "package:dungeons/game/source.dart";
import "package:dungeons/game/spell.dart";
import "package:dungeons/game/status_effects.dart";
import "package:dungeons/game/value.dart";
import "package:dungeons/utility/dice.dart";
import "package:dungeons/utility/monoids.dart";

final class SpellCastInput extends ActionInput {
  final Spell spell;
  final Entity caster;
  @override
  final Entity target;

  const SpellCastInput(
    this.spell, {
    required this.caster,
    required this.target,
  });

  @override
  Entity get actor => caster;

  bool get autoHit => spell.autoHit || spell.friendly;
  bool get targetSelf => caster == target;

  Value<Percent> get resistChance =>
      autoHit ? Value.fromBase(Percent.zero) : target.resist;

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

  bool get canEffect {
    if (spell.effect != null) {
      final bonus = SpellBonus(spell);
      return spell.stacks || !target.hasBonus(bonus);
    }
    return true;
  }

  SpellCastRolls roll() {
    return SpellCastRolls(
      resist: ChanceRoll(),
      damage: spell.damage?.roll(),
      heal: spell.heals?.roll(),
    );
  }
}

class SpellCastRolls {
  final ChanceRoll resist;
  final DiceRoll? damage;
  final DiceRoll? heal;

  const SpellCastRolls({
    required this.resist,
    this.damage,
    this.heal,
  });
}

final class SpellCastResult extends ActionResult {
  @override
  final SpellCastInput input;
  final SpellCastRolls rolls;
  @override
  final StatusEffects inflicted;

  const SpellCastResult(this.input, this.rolls, this.inflicted);

  factory SpellCastResult.from(SpellCastInput input, SpellCastRolls rolls) {
    final spell = input.spell;
    final inflicted = StatusEffects([
      if (input.canEffect && spell.effect != null)
        BonusEntry(SpellBonus(spell), spell.effect!),
    ]);
    return SpellCastResult(input, rolls, inflicted);
  }

  bool get canResist => !input.autoHit;
  @override
  bool get didHit => !canResist || rolls.resist.failsV(input.resistChance);
  bool get resisted => !didHit;
  @override
  int get damageDone => rolls.damage?.total ?? 0;
  @override
  int get healingDone => rolls.heal?.total ?? 0;
}

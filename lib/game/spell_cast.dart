import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/source.dart';
import 'package:dungeons/game/spell.dart';
import 'package:dungeons/game/value.dart';
import 'package:dungeons/utility/dice.dart';
import 'package:dungeons/utility/if.dart';
import 'package:dungeons/utility/percent.dart';

class SpellCast {
  final Spell spell;
  final Entity from;
  final Entity target;

  const SpellCast(this.spell, {required this.from, required this.target});

  bool get self => from == target;

  PercentValue get resistChance =>
      spell.autoHit ? const PercentValue() : target.resist;

  Source get source => spell.source;

  SpellCastResult roll() {
    final affected = target.canSpellEffect(spell);
    if (self) {
      return SpellCastResult(
        affected: affected,
        healDice: spell.heals?.roll(),
      );
    }
    final resist = ifnot(spell.autoHit, resistChance.roll);
    final hit = resist?.success != true;
    return SpellCastResult(
      resist: resist,
      damageDice: ifyes(hit, spell.damage?.roll),
      affected: hit && affected,
    );
  }

  void apply(SpellCastResult result) {
    if (from.player) {
      from.addStress(spell.stress);
    }
    target.heal(result.healDice?.total ?? 0);
    target.takeDamage(result.damageDice?.total ?? 0);
    if (result.affected) {
      target.addSpellEffect(spell);
    }
  }
}

class SpellCastResult {
  final bool affected;
  final PercentRoll? resist;
  final DiceRoll? damageDice;
  final DiceRollValue? healDice;

  const SpellCastResult({
    required this.affected,
    this.resist,
    this.damageDice,
    this.healDice,
  });

  IntValue? get damage =>
      ifdef(damageDice, (dice) => IntValue(base: dice.total));

  IntValue? get heal => ifdef(healDice, (dice) => IntValue(base: dice.total));
}

class SpellCastTurn {
  final SpellCast attack;
  final SpellCastResult result;

  const SpellCastTurn._(this.attack, this.result);

  factory SpellCastTurn(SpellCast attack) {
    return SpellCastTurn._(attack, attack.roll());
  }

  void apply() {
    attack.apply(result);
  }
}

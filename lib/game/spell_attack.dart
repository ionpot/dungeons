import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/source.dart';
import 'package:dungeons/game/spell.dart';
import 'package:dungeons/game/value.dart';
import 'package:dungeons/utility/dice.dart';
import 'package:dungeons/utility/if.dart';
import 'package:dungeons/utility/percent.dart';

class SpellAttack {
  final Spell spell;
  final Entity from;
  final Entity target;

  const SpellAttack(this.spell, {required this.from, required this.target});

  bool get self => from == target;

  PercentValue get resistChance =>
      spell.autoHit ? const PercentValue() : target.resist;

  bool get autoHit => spell.autoHit;
  Source get source => spell.source;

  SpellAttackResult roll() {
    final affected = target.canSpellEffect(spell);
    if (self) {
      return SpellAttackResult(
        affected: affected,
        healDice: spell.heals?.roll(),
      );
    }
    final resist = ifnot(autoHit, resistChance.roll);
    final hit = autoHit ? true : resist?.fail == true;
    return SpellAttackResult(
      resist: resist,
      damageDice: ifyes(hit, spell.damage?.roll),
      affected: hit && spell.effect != null && affected,
    );
  }

  void apply(SpellAttackResult result) {
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

class SpellAttackResult {
  final bool affected;
  final PercentRoll? resist;
  final DiceRoll? damageDice;
  final DiceRollValue? healDice;

  const SpellAttackResult({
    required this.affected,
    this.resist,
    this.damageDice,
    this.healDice,
  });

  IntValue? get damage =>
      ifdef(damageDice, (dice) => IntValue(base: dice.total));

  IntValue? get heal => ifdef(healDice, (dice) => IntValue(base: dice.total));
}

class SpellAttackTurn {
  final SpellAttack attack;
  final SpellAttackResult result;

  const SpellAttackTurn._(this.attack, this.result);

  factory SpellAttackTurn(SpellAttack attack) {
    return SpellAttackTurn._(attack, attack.roll());
  }

  void apply() {
    attack.apply(result);
  }
}

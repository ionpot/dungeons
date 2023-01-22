import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/source.dart';
import 'package:dungeons/game/spell.dart';
import 'package:dungeons/game/value.dart';
import 'package:dungeons/utility/dice.dart';
import 'package:dungeons/utility/if.dart';

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
        heal: _roll(spell.heals),
      );
    }
    final resist = ifnot(spell.autoHit, resistChance.roll);
    final hit = resist?.success != true;
    return SpellCastResult(
      resist: resist,
      damage: ifyes(hit, () => _roll(spell.damage)),
      affected: hit && affected,
    );
  }

  void apply(SpellCastResult result) {
    if (from.player) {
      from.addStress(spell.stress);
    }
    ifdef(result.heal?.total, target.heal);
    ifdef(result.damage?.total, target.takeDamage);
    if (result.affected) {
      target.addSpellEffect(spell);
    }
  }

  DiceRollValue? _roll(Dice? dice) {
    return ifdef(dice, DiceRollValue.roll);
  }
}

class SpellCastResult {
  final bool affected;
  final PercentValueRoll? resist;
  final DiceRollValue? damage;
  final DiceRollValue? heal;

  const SpellCastResult({
    required this.affected,
    this.resist,
    this.damage,
    this.heal,
  });
}

class SpellCastTurn {
  final SpellCast attack;
  final SpellCastResult result;

  const SpellCastTurn(this.attack, this.result);

  void apply() {
    attack.apply(result);
  }
}

import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/source.dart';
import 'package:dungeons/game/spell.dart';
import 'package:dungeons/game/value.dart';
import 'package:dungeons/utility/dice.dart';
import 'package:dungeons/utility/if.dart';

class SpellCast {
  final Spell spell;
  final Entity caster;
  final Entity target;

  const SpellCast(this.spell, {required this.caster, required this.target});

  bool get self => caster == target;

  PercentValue get resistChance =>
      spell.autoHit ? const PercentValue() : target.resist;

  Source get source => spell.source;

  SpellCastResult roll() {
    return SpellCastResult(
      autoHit: spell.autoHit,
      canEffect: target.canSpellEffect(spell),
      resistRoll: resistChance.roll(),
      targetSelf: self,
      damageRoll: _roll(spell.damage),
      healRoll: _roll(spell.heals),
    );
  }

  void apply(SpellCastResult result) {
    if (caster.player) {
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

class SpellCastResult {
  final bool autoHit;
  final bool canEffect;
  final PercentValueRoll resistRoll;
  final bool targetSelf;
  final DiceRollValue? damageRoll;
  final DiceRollValue? healRoll;

  const SpellCastResult({
    required this.autoHit,
    required this.canEffect,
    required this.resistRoll,
    required this.targetSelf,
    this.damageRoll,
    this.healRoll,
  });

  bool get canResist => !targetSelf && !autoHit;
  bool get didEffect => targetSelf ? canEffect : didHit && canEffect;
  bool get didHit => !canResist || resistRoll.fail;
  bool get resisted => !didHit;

  int? get damageDone => didHit ? damageRoll?.total : null;
  int? get healDone => didHit ? healRoll?.total : null;
}

class SpellCastTurn {
  final SpellCast cast;
  final SpellCastResult result;

  const SpellCastTurn(this.cast, this.result);

  void apply() {
    cast.apply(result);
  }
}

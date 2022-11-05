import 'package:dungeons/game/damage.dart';
import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/spell.dart';
import 'package:dungeons/utility/if.dart';
import 'package:dungeons/utility/percent.dart';

class SpellAttack {
  final Spell spell;
  final Entity from;
  final Entity target;

  const SpellAttack(this.spell, {required this.from, required this.target});

  Percent get resistChance => spell.autoHit ? const Percent() : target.resist;
  DamageDice? get damage => spell.damage;

  SpellAttackResult roll() {
    final resist = resistChance.roll();
    return SpellAttackResult(
      resist: resist,
      damage: ifyes(resist.fail, () => damage?.roll()),
    );
  }

  void apply(SpellAttackResult result) {
    if (from.player) {
      from.addStress(spell.stress);
    }
    target.takeDamage(result.damage?.total ?? 0);
  }
}

class SpellAttackResult {
  final PercentRoll resist;
  final Damage? damage;

  const SpellAttackResult({
    required this.resist,
    this.damage,
  });
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

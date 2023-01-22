import 'package:dungeons/game/effect.dart';
import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/feat.dart';
import 'package:dungeons/game/source.dart';
import 'package:dungeons/game/value.dart';
import 'package:dungeons/utility/dice.dart';
import 'package:dungeons/utility/if.dart';

class WeaponAttack {
  final Entity from;
  final Entity target;

  const WeaponAttack({required this.from, required this.target});

  PercentValue get hitChance => from.hitChance(target);
  PercentValue get dodgeChance => target.dodge;
  bool get sneakAttack => from.canSneakAttack(target);
  Source get source => Source.physical;

  DiceValue? get damage {
    return ifdef(from.weaponDamage, (value) {
      return sneakAttack
          ? (value..addDice(_SneakAttack.effect, _SneakAttack.dice))
          : value;
    });
  }

  WeaponAttackResult roll() {
    final hit = hitChance.roll();
    final dodge = ifyes(hit.success, dodgeChance.roll);
    final damage = ifyes(dodge?.fail, this.damage?.roll);
    return WeaponAttackResult(
      hit: hit,
      dodge: dodge,
      damage: damage,
    );
  }

  void apply(WeaponAttackResult result) {
    target.takeDamage(result.damage?.total ?? 0);
  }
}

class WeaponAttackResult {
  final PercentValueRoll hit;
  final PercentValueRoll? dodge;
  final DiceRollValue? damage;

  const WeaponAttackResult({
    required this.hit,
    this.dodge,
    this.damage,
  });
}

class WeaponAttackTurn {
  final WeaponAttack attack;
  final WeaponAttackResult result;

  const WeaponAttackTurn(this.attack, this.result);

  void apply() {
    attack.apply(result);
  }
}

class _SneakAttack {
  static const effect = Effect(feat: Feat.sneakAttack);
  static Dice get dice {
    return Feat.sneakAttack.dice ??
        (throw Exception("Feat.sneakAttack.dice is null"));
  }
}

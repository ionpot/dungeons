import 'package:dungeons/game/bonus.dart';
import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/feat.dart';
import 'package:dungeons/game/source.dart';
import 'package:dungeons/game/value.dart';
import 'package:dungeons/utility/dice.dart';

class WeaponAttack {
  final Entity attacker;
  final Entity target;

  const WeaponAttack({required this.attacker, required this.target});

  PercentValue get hitChance => attacker.hitChance(target);
  PercentValue get dodgeChance => target.dodge;
  bool get sneakAttack => attacker.canSneakAttack(target);
  Source get source => Source.physical;

  DiceValue get damage {
    final value = attacker.weaponDamage;
    if (value == null) {
      throw Exception('$attacker.weaponDamage is null');
    }
    return sneakAttack
        ? (value..addDice(_SneakAttack.bonus, _SneakAttack.dice))
        : value;
  }

  WeaponAttackResult roll() {
    return WeaponAttackResult(
      attackRoll: hitChance.roll(),
      dodgeRoll: dodgeChance.roll(),
      damageRoll: damage.roll(),
      targetCanDodge: target.canDodge,
    );
  }

  void apply(WeaponAttackResult result) {
    if (result.didHit) {
      target.takeDamage(result.damageDone);
    }
  }
}

class WeaponAttackResult {
  final PercentValueRoll attackRoll;
  final PercentValueRoll dodgeRoll;
  final DiceRollValue damageRoll;
  final bool targetCanDodge;

  const WeaponAttackResult({
    required this.attackRoll,
    required this.dodgeRoll,
    required this.damageRoll,
    required this.targetCanDodge,
  });

  bool get deflected => attackRoll.fail;
  bool get triedDodging => targetCanDodge && attackRoll.success;
  bool get cantDodge => !targetCanDodge && attackRoll.success;
  bool get dodged => triedDodging && dodgeRoll.success;
  bool get didHit => !deflected && !dodged;
  int get damageDone => damageRoll.total;
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
  static const bonus = Bonus(feat: Feat.sneakAttack);
  static Dice get dice {
    return Feat.sneakAttack.dice ??
        (throw Exception("Feat.sneakAttack.dice is null"));
  }
}

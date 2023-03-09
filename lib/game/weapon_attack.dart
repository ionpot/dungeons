import 'package:dungeons/game/bonus.dart';
import 'package:dungeons/game/critical_hit.dart';
import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/feat.dart';
import 'package:dungeons/game/source.dart';
import 'package:dungeons/game/value.dart';

class WeaponAttack {
  final Entity attacker;
  final Entity target;

  const WeaponAttack({required this.attacker, required this.target});

  PercentValue get hitChance => attacker.hitChance(target);
  PercentValue get dodgeChance => target.dodge;
  DiceValue get weaponDamage => attacker.weaponDamage!;
  Source get source => Source.physical;

  WeaponAttackResult roll() {
    return WeaponAttackResult(
      attackRoll: hitChance.roll(),
      dodgeRoll: dodgeChance.roll(),
      damageRoll: weaponDamage.roll(),
      targetCanDodge: target.canDodge,
      criticalHit: attacker.criticalHit,
      sneakAttack: attacker.sneakAttack(target),
    );
  }

  void apply(WeaponAttackResult result) {
    if (result.didDamage) {
      target.takeDamage(result.damageDone);
    }
  }
}

class WeaponAttackResult {
  final PercentValueRoll attackRoll;
  final PercentValueRoll dodgeRoll;
  final DiceRollValue damageRoll;
  final CriticalHit criticalHit;
  final bool targetCanDodge;

  WeaponAttackResult({
    required this.attackRoll,
    required this.dodgeRoll,
    required this.damageRoll,
    required this.targetCanDodge,
    required this.criticalHit,
    FeatSlot? sneakAttack,
  }) {
    if (isCriticalHit) {
      damageRoll.diceBonuses.add(
        Bonus(criticalHit: criticalHit),
        criticalHit.dice.roll(),
      );
    }
    if (sneakAttack != null) {
      damageRoll.diceBonuses.add(
        Bonus(feat: sneakAttack),
        sneakAttack.value.dice!.roll(),
      );
    }
  }

  bool get isCriticalHit => attackRoll.meets(criticalHit.chance.total);

  bool get autoHit => isCriticalHit;
  bool get canDodge => !autoHit && targetCanDodge;
  bool get deflected => !autoHit && attackRoll.fail;
  bool get rolledDodge => !deflected && canDodge;
  bool get dodged => rolledDodge && dodgeRoll.success;
  bool get didDamage => !deflected && !dodged;
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

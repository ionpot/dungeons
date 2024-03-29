import "package:dungeons/game/combat/action_input.dart";
import "package:dungeons/game/combat/chance_roll.dart";
import "package:dungeons/game/entity.dart";
import "package:dungeons/game/entity/bonus.dart";
import "package:dungeons/game/entity/critical_hit.dart";
import "package:dungeons/game/entity/dice_value.dart";
import "package:dungeons/game/entity/feat.dart";
import "package:dungeons/game/entity/value.dart";
import "package:dungeons/utility/dice.dart";
import "package:dungeons/utility/monoids.dart";

class WeaponAttackInput extends ActionInput {
  @override
  final Entity actor;
  @override
  final Entity target;

  const WeaponAttackInput({
    required this.actor,
    required this.target,
  });

  Value<Percent> get hitChance => actor.hitChance(target);
  Value<Percent> get dodgeChance => target.dodge;
  DiceValue get weaponDamage => actor.weaponDamage!;
  Dice get weaponDice => actor.gear.weaponValue!.dice!;

  CriticalHit get criticalHit {
    return CriticalHit(
      chance: actor.criticalHitChance,
      dice: weaponDice,
    );
  }

  FeatSlot? get sneakAttack {
    if (actor.fasterThan(target)) {
      return actor.feats.find(Feat.sneakAttack);
    }
    return null;
  }

  DiceRollValue rollDamage() => weaponDamage.roll();
  DiceRoll rollCriticalHit() => criticalHit.dice.roll();
  DiceRoll? rollSneakAttack() => sneakAttack?.value.dice!.roll();

  WeaponAttackRolls roll() {
    return WeaponAttackRolls(
      attack: ChanceRoll(),
      dodge: ChanceRoll(),
      damage: rollDamage(),
      critical: rollCriticalHit(),
      sneakAttack: rollSneakAttack(),
    );
  }
}

class WeaponAttackRolls {
  final ChanceRoll attack;
  final ChanceRoll dodge;
  final DiceRollValue damage;
  final DiceRoll? critical;
  final DiceRoll? sneakAttack;

  const WeaponAttackRolls({
    required this.attack,
    required this.dodge,
    required this.damage,
    this.critical,
    this.sneakAttack,
  });
}

class WeaponAttackResult extends ActionResult {
  @override
  final WeaponAttackInput input;
  final WeaponAttackRolls rolls;

  WeaponAttackResult(this.input, this.rolls) {
    if (isCriticalHit && rolls.critical != null) {
      rolls.damage.addBonusRoll(
        CriticalHitBonus(input.criticalHit),
        rolls.critical!,
      );
    }
    if (rolls.sneakAttack != null) {
      rolls.damage.addBonusRoll(
        FeatBonus(input.sneakAttack!),
        rolls.sneakAttack!,
      );
    }
    if (target.isDefending) {
      rolls.damage.intBonuses.add(
        OtherBonus.defending,
        Int(damageDone).half.negate,
      );
    }
  }

  bool get isCriticalHit {
    return rolls.attack.meetsV(input.criticalHit.chance);
  }

  bool get autoHit => isCriticalHit;
  bool get canDodge => !autoHit && input.target.canDodge;
  bool get deflected => !autoHit && rolls.attack.failsV(input.hitChance);
  bool get rolledDodge => !deflected && canDodge;
  bool get dodged => rolledDodge && rolls.dodge.meetsV(input.dodgeChance);

  @override
  bool get didHit => !deflected && !dodged;

  @override
  int get damageDone => rolls.damage.total;
}

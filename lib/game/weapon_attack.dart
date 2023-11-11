import 'package:dungeons/game/bonus.dart';
import 'package:dungeons/game/bonuses.dart';
import 'package:dungeons/game/combat_action.dart';
import 'package:dungeons/game/critical_hit.dart';
import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/feat.dart';
import 'package:dungeons/game/smite.dart';
import 'package:dungeons/game/source.dart';
import 'package:dungeons/game/value.dart';
import 'package:dungeons/game/weapon.dart';
import 'package:dungeons/utility/dice.dart';
import 'package:dungeons/utility/percent.dart';

class WeaponAttack extends ActionParameters {
  final Entity attacker;
  @override
  final Entity target;
  final bool smite;
  final bool useOffHand;

  const WeaponAttack({
    required this.attacker,
    required this.target,
    this.smite = false,
    this.useOffHand = false,
  });

  @override
  Entity get actor => attacker;

  @override
  int get stressCost {
    if (useOffHand) {
      return TwoWeaponAttack.stressCost;
    }
    if (smite) {
      return Smite.stressCost;
    }
    return 0;
  }

  TwoWeaponAttack? get twoWeaponAttack =>
      useOffHand ? TwoWeaponAttack(attacker, target) : null;

  PercentValueRoll rollHitChance() {
    return twoWeaponAttack?.rollHitChance() ??
        attacker.hitChance(target).roll(smite ? Smite.rolls : 1);
  }

  PercentValue get dodgeChance => target.dodge;
  DiceValue get weaponDamage => attacker.weaponDamage!;

  @override
  Source get source => smite ? Smite.source : Source.physical;

  @override
  WeaponAttackResult toResult() {
    return WeaponAttackResult(
      attackRoll: rollHitChance(),
      dodgeRoll: dodgeChance.roll(),
      damageRoll: weaponDamage.roll(),
      targetCanDodge: target.canDodge,
      criticalHit: attacker.criticalHit,
      sneakAttack: attacker.sneakAttack(target),
      twoWeaponAttack: twoWeaponAttack,
    );
  }

  @override
  WeaponAttackResult downcast(ActionResult result) {
    if (result is WeaponAttackResult) {
      return result;
    }
    throw ArgumentError.value(result, "result");
  }
}

class WeaponAttackResult extends ActionResult {
  final PercentValueRoll attackRoll;
  final PercentValueRoll dodgeRoll;
  final DiceRollValue damageRoll;
  final CriticalHit criticalHit;
  final bool targetCanDodge;
  final TwoWeaponAttack? twoWeaponAttack;

  WeaponAttackResult({
    required this.attackRoll,
    required this.dodgeRoll,
    required this.damageRoll,
    required this.targetCanDodge,
    required this.criticalHit,
    this.twoWeaponAttack,
    FeatSlot? sneakAttack,
  }) {
    if (twoWeaponAttack != null && attackRoll.allSuccess) {
      damageRoll.diceBonuses.add(
        GearBonus.offHand(twoWeaponAttack!.offHand),
        twoWeaponAttack!.damageDice.roll(),
      );
    }
    if (isCriticalHit) {
      damageRoll.diceBonuses.add(
        CriticalHitBonus(criticalHit),
        criticalHit.dice.roll(),
      );
    }
    if (sneakAttack != null) {
      damageRoll.diceBonuses.add(
        FeatBonus(sneakAttack),
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

  @override
  bool get didHit => !deflected && !dodged;

  @override
  int get damageDone => damageRoll.total;
}

class TwoWeaponAttack {
  final Entity attacker;
  final Entity target;

  static const int stressCost = 1;
  static const int hitRolls = 2;
  static const Percent hitBonus = Percent(-15);

  const TwoWeaponAttack(this.attacker, this.target);

  Dice get damageDice => attacker.gear.offHandValue!.dice;

  Weapon get offHand => attacker.offHandWeapon!;

  PercentValue get hitChance {
    final base = attacker.hitChanceBase(target);
    final map = attacker.hitChanceBonusMap;
    map[GearBonus.offHand(offHand)] = hitBonus;
    return PercentValue(base: base, bonuses: PercentBonuses(map));
  }

  PercentValueRoll rollHitChance() => hitChance.roll(hitRolls);
}

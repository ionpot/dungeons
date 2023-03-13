import 'package:dungeons/game/bonus.dart';
import 'package:dungeons/game/bonuses.dart';
import 'package:dungeons/game/critical_hit.dart';
import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/feat.dart';
import 'package:dungeons/game/smite.dart';
import 'package:dungeons/game/source.dart';
import 'package:dungeons/game/value.dart';
import 'package:dungeons/game/weapon.dart';
import 'package:dungeons/utility/dice.dart';
import 'package:dungeons/utility/percent.dart';

class WeaponAttack {
  final Entity attacker;
  final Entity target;
  final bool smite;
  final bool useOffHand;

  const WeaponAttack({
    required this.attacker,
    required this.target,
    this.smite = false,
    this.useOffHand = false,
  });

  TwoWeaponAttack? get twoWeaponAttack =>
      useOffHand ? TwoWeaponAttack(attacker, target) : null;

  PercentValueRoll rollHitChance() {
    return twoWeaponAttack?.rollHitChance() ??
        attacker.hitChance(target).roll(smite ? Smite.rolls : 1);
  }

  PercentValue get dodgeChance => target.dodge;
  DiceValue get weaponDamage => attacker.weaponDamage!;
  Source get source => smite ? Smite.source : Source.physical;

  WeaponAttackResult roll() {
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

  void apply(WeaponAttackResult result) {
    if (smite) {
      attacker.addStress(Smite.stressCost);
    }
    if (result.twoWeaponAttack != null) {
      result.twoWeaponAttack!.apply();
    }
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
        Bonus(offHand: twoWeaponAttack!.offHand),
        twoWeaponAttack!.damageDice.roll(),
      );
    }
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

class TwoWeaponAttack {
  final Entity attacker;
  final Entity target;

  static const int stressCost = 1;
  static const int hitRolls = 2;
  static const Percent hitBonus = Percent(-10);

  static bool hasStress(Entity entity) => entity.hasStress(stressCost);
  static bool possible(Entity entity) => entity.gear.hasTwoWeapons;

  const TwoWeaponAttack(this.attacker, this.target);

  Dice get damageDice => attacker.gear.offHandValue!.dice;

  Weapon get offHand => attacker.offHandWeapon!;

  PercentValue get hitChance {
    final base = attacker.hitChanceBase(target);
    final map = attacker.hitChanceBonusMap;
    map[Bonus(offHand: offHand)] = hitBonus;
    return PercentValue(base: base, bonuses: PercentBonuses(map));
  }

  PercentValueRoll rollHitChance() => hitChance.roll(hitRolls);

  void apply() {
    attacker.addStress(stressCost);
  }
}

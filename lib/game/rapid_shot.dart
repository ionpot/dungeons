import "package:dungeons/game/bonus.dart";
import "package:dungeons/game/chance_roll.dart";
import "package:dungeons/game/value.dart";
import "package:dungeons/game/weapon_attack.dart";
import "package:dungeons/utility/dice.dart";
import "package:dungeons/utility/monoids.dart";

class RapidShot {
  static const bonus = OtherBonus("Rapid Shot");
  static const hitChanceBonus = Percent(-15);
  static const hitRolls = 2;
  static const stressCost = 2;
}

class RapidShotInput extends WeaponAttackInput {
  const RapidShotInput({required super.actor, required super.target});

  @override
  int get stressCost => RapidShot.stressCost;

  @override
  Value<Percent> get hitChance {
    return super.hitChance
      ..bonuses.add(RapidShot.bonus, RapidShot.hitChanceBonus);
  }

  @override
  RapidShotRolls roll() {
    return RapidShotRolls(
      attack: ChanceRoll(RapidShot.hitRolls),
      dodge: ChanceRoll(),
      damage: super.rollDamage(),
      critical: super.rollCriticalHit(),
      extraDamage: super.weaponDice.roll(),
    );
  }
}

class RapidShotRolls extends WeaponAttackRolls {
  final DiceRoll extraDamage;

  RapidShotRolls({
    required super.attack,
    required super.dodge,
    required super.damage,
    required super.critical,
    required this.extraDamage,
  });
}

class RapidShotResult extends WeaponAttackResult {
  final RapidShotInput _input;
  final RapidShotRolls _rolls;

  RapidShotResult(this._input, this._rolls) : super(_input, _rolls) {
    if (_didExtraDamage) {
      _rolls.damage.addBonusRoll(RapidShot.bonus, _rolls.extraDamage);
    }
  }

  bool get _didExtraDamage {
    return didHit && _rolls.attack.allMeetV(_input.hitChance);
  }

  @override
  WeaponAttackInput get input => _input;

  @override
  WeaponAttackRolls get rolls => _rolls;
}

import "package:dungeons/game/bonus.dart";
import "package:dungeons/game/chance_roll.dart";
import "package:dungeons/game/value.dart";
import "package:dungeons/game/weapon.dart";
import "package:dungeons/game/weapon_attack.dart";
import "package:dungeons/utility/dice.dart";
import "package:dungeons/utility/monoids.dart";

class TwoWeaponAttack {
  static const int hitRolls = 2;
  static const Percent hitBonus = Percent(-15);
  static const int stressCost = 2;
}

final class TwoWeaponAttackInput extends WeaponAttackInput {
  const TwoWeaponAttackInput({
    required super.actor,
    required super.target,
  });

  @override
  int get stressCost => TwoWeaponAttack.stressCost;

  Dice get offHandDice => actor.gear.offHandValue!.dice!;

  Weapon get offHand => actor.offHandWeapon!;

  @override
  Value<Percent> get hitChance {
    return super.hitChance
      ..bonuses.add(
        GearBonus.offHand(offHand),
        TwoWeaponAttack.hitBonus,
      );
  }

  @override
  TwoWeaponAttackRolls roll() {
    return TwoWeaponAttackRolls(
      attack: ChanceRoll(TwoWeaponAttack.hitRolls),
      dodge: ChanceRoll(),
      damage: super.rollDamage(),
      critical: super.rollCriticalHit(),
      offHand: offHandDice.roll(),
    );
  }
}

final class TwoWeaponAttackRolls extends WeaponAttackRolls {
  final DiceRoll offHand;
  const TwoWeaponAttackRolls({
    required super.attack,
    required super.dodge,
    required super.damage,
    required super.critical,
    required this.offHand,
  });
}

final class TwoWeaponAttackResult extends WeaponAttackResult {
  final TwoWeaponAttackInput _input;
  final TwoWeaponAttackRolls _rolls;

  TwoWeaponAttackResult(this._input, this._rolls) : super(_input, _rolls) {
    if (_didHitWithOffhand) {
      _rolls.damage.addBonusRoll(
        GearBonus.offHand(_input.offHand),
        _rolls.offHand,
      );
    }
  }

  bool get _didHitWithOffhand {
    return didHit && _rolls.attack.allMeetV(_input.hitChance);
  }

  @override
  WeaponAttackInput get input => _input;

  @override
  WeaponAttackRolls get rolls => _rolls;
}

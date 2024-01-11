import "package:dungeons/game/combat/chance_roll.dart";
import "package:dungeons/game/combat/weapon_attack.dart";
import "package:dungeons/game/source.dart";

class Smite {
  static const int hitRolls = 2;
  static const int stressCost = 4;
  static const Source source = Source.radiant;
}

class SmiteInput extends WeaponAttackInput {
  const SmiteInput({required super.actor, required super.target});

  @override
  int get stressCost => Smite.stressCost;

  @override
  Source get source => Smite.source;

  @override
  WeaponAttackRolls roll() {
    return WeaponAttackRolls(
      attack: ChanceRoll(Smite.hitRolls),
      dodge: ChanceRoll(),
      damage: super.rollDamage(),
      critical: super.rollCriticalHit(),
      sneakAttack: super.rollSneakAttack(),
    );
  }
}

class SmiteResult extends WeaponAttackResult {
  final SmiteInput _input;

  SmiteResult(this._input, WeaponAttackRolls rolls) : super(_input, rolls);

  @override
  WeaponAttackInput get input => _input;
}

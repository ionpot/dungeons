import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/value.dart';
import 'package:dungeons/utility/dice.dart';
import 'package:dungeons/utility/if.dart';
import 'package:dungeons/utility/percent.dart';

class WeaponAttack {
  final Entity from;
  final Entity target;

  const WeaponAttack({required this.from, required this.target});

  PercentValue get hitChance => from.hitChance(target);
  PercentValue get dodgeChance => target.dodge;
  DiceValue? get damage => from.damage;
  Dice? get sneakDamage => from.sneakDamage(target);

  WeaponAttackResult roll() {
    final hit = hitChance.roll();
    final dodge = hit.success ? dodgeChance.roll() : null;
    final weapon = ifyes(dodge?.fail, damage?.roll);
    final sneak = ifok(weapon, sneakDamage?.roll);
    return WeaponAttackResult(
      hit: hit,
      dodge: dodge,
      weaponDamage: weapon,
      sneakDamage: sneak,
    );
  }

  void apply(WeaponAttackResult result) {
    target.takeDamage(result.damage?.total ?? 0);
  }
}

class WeaponAttackResult {
  final PercentRoll hit;
  final PercentRoll? dodge;
  final DiceRollValue? weaponDamage;
  final DiceRoll? sneakDamage;

  const WeaponAttackResult({
    required this.hit,
    this.dodge,
    this.weaponDamage,
    this.sneakDamage,
  });

  IntValue? get damage {
    return ifdef(weaponDamage, (wd) {
      return wd.value.addBonus(sneakDamage?.total ?? 0);
    });
  }
}

class WeaponAttackTurn {
  final WeaponAttack attack;
  final WeaponAttackResult result;

  const WeaponAttackTurn._(this.attack, this.result);

  factory WeaponAttackTurn(WeaponAttack attack) {
    return WeaponAttackTurn._(attack, attack.roll());
  }

  void apply() {
    attack.apply(result);
  }
}

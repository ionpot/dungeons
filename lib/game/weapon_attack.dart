import 'package:dungeons/game/effect.dart';
import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/feat.dart';
import 'package:dungeons/game/source.dart';
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
  DiceValue? get damage => from.weaponDamage;
  Dice? get sneakDamage => from.sneakDamage(target);
  Source get source => Source.physical;

  WeaponAttackResult roll() {
    final hit = hitChance.roll();
    final dodge = ifyes(hit.success, dodgeChance.roll);
    final weapon = ifyes(dodge?.fail, () {
      return ifdef(damage, (d) {
        return from.hasMaxWeaponDamage() ? d.rollMax() : d.roll();
      });
    });
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

  // TODO refactor
  IntValue? get damage {
    return ifdef(weaponDamage?.value, (value) {
      ifdef(sneakDamage?.total, (sneak) {
        value.addBonus(const Effect(feat: Feat.sneakAttack), sneak);
      });
      return value;
    });
  }
}

class WeaponAttackTurn {
  final WeaponAttack attack;
  final WeaponAttackResult result;

  const WeaponAttackTurn(this.attack, this.result);

  void apply() {
    attack.apply(result);
  }
}

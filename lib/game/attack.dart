import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/value.dart';
import 'package:dungeons/utility/dice.dart';
import 'package:dungeons/utility/if.dart';
import 'package:dungeons/utility/percent.dart';

class Attack {
  final Entity from;
  final Entity target;

  const Attack({required this.from, required this.target});

  PercentValue get hitChance => from.hitChance(target);
  PercentValue get dodgeChance => target.dodge;
  DiceValue? get damage => from.damage;
  Dice? get sneakDamage => from.sneakDamage(target);

  AttackResult roll() {
    final hit = hitChance.roll();
    final dodge = hit.success ? dodgeChance.roll() : null;
    final weapon = ifyes(dodge?.fail, () => damage?.roll());
    final sneak = ifdef(weapon, (_) => sneakDamage?.roll());
    return AttackResult(
      hit: hit,
      dodge: dodge,
      weaponDamage: weapon,
      sneakDamage: sneak,
    );
  }

  void apply(AttackResult result) {
    target.takeDamage(result.damage?.total ?? 0);
  }
}

class AttackResult {
  final PercentRoll hit;
  final PercentRoll? dodge;
  final IntValue? weaponDamage;
  final int? sneakDamage;

  const AttackResult({
    required this.hit,
    this.dodge,
    this.weaponDamage,
    this.sneakDamage,
  });

  IntValue? get damage =>
      ifdef(weaponDamage, (wd) => wd.addBonus(sneakDamage ?? 0));
}

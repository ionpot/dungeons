import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/value.dart';
import 'package:dungeons/utility/percent.dart';

class Attack {
  final Entity from;
  final Entity target;
  final AttackValue value;
  final AttackResult result;

  const Attack({
    required this.from,
    required this.target,
    required this.value,
    required this.result,
  });

  factory Attack.make({required Entity from, required Entity target}) {
    final value = AttackValue(from: from, target: target);
    return Attack(
      from: from,
      target: target,
      value: value,
      result: value.roll(),
    );
  }

  void apply() {
    target.takeDamage(result.damage ?? 0);
  }
}

class AttackValue {
  final PercentValue hitChance;
  final PercentValue dodgeChance;
  final DiceValue damage;

  AttackValue({
    required Entity from,
    required Entity target,
  })  : hitChance = from.hitChance(target),
        dodgeChance = target.dodge,
        damage = from.damage!;

  AttackResult roll() {
    final hit = hitChance.roll();
    final dodge = hit.success ? dodgeChance.roll() : null;
    return AttackResult(
      hit: hit,
      dodge: dodge,
      damage: (dodge != null && dodge.fail) ? damage.roll() : null,
    );
  }
}

class AttackResult {
  final PercentRoll hit;
  final PercentRoll? dodge;
  final int? damage;

  const AttackResult({required this.hit, this.dodge, this.damage});
}

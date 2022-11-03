import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/value.dart';
import 'package:dungeons/utility/percent.dart';

class Attack {
  final Entity from;
  final Entity target;

  const Attack({required this.from, required this.target});

  PercentValue get hitChance => from.hitChance(target);
  PercentValue get dodgeChance => target.dodge;
  DiceValue? get damage => from.damage;

  AttackResult roll() {
    final hit = hitChance.roll();
    final dodge = hit.success ? dodgeChance.roll() : null;
    return AttackResult(
      hit: hit,
      dodge: dodge,
      damage: (dodge != null && dodge.fail) ? damage?.roll() : null,
    );
  }

  void apply(AttackResult result) {
    target.takeDamage(result.damage?.total ?? 0);
  }
}

class AttackResult {
  final PercentRoll hit;
  final PercentRoll? dodge;
  final IntValue? damage;

  const AttackResult({required this.hit, this.dodge, this.damage});
}

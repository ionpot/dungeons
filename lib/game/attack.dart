import 'package:dungeons/game/entity.dart';
import 'package:dungeons/utility/percent.dart';

class Attack {
  final Entity from;
  final Entity target;
  late final PercentRoll roll;
  PercentRoll? dodge;
  int? damage;

  Attack({required this.from, required this.target}) {
    roll = PercentRoll(from.toHit(target));
    if (roll.success) {
      dodge = PercentRoll(target.dodge.total);
      if (dodge!.fail) {
        damage = from.damageDice?.roll();
      }
    }
  }

  void apply() {
    if (damage != null) target.takeDamage(damage!);
  }
}

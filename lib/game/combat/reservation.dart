import "package:dungeons/game/entity.dart";
import "package:dungeons/game/entity/bonus.dart";

class Reservation {
  final Entity actor;
  final Entity target;
  final Bonus bonus;

  Reservation(this.actor, this.target, this.bonus);
}

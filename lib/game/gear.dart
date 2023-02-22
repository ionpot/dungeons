import 'package:dungeons/game/armor.dart';
import 'package:dungeons/game/bonuses.dart';
import 'package:dungeons/game/weapon.dart';
import 'package:dungeons/utility/if.dart';

class Gear {
  Armor? body;
  Weapon? mainHand;

  Gear({this.body, this.mainHand});

  int get armor => body?.value ?? 0;

  Bonuses get bonuses {
    final bonuses = Bonuses();
    ifdef(body, bonuses.addArmor);
    ifdef(mainHand, bonuses.addWeapon);
    return bonuses;
  }

  void roll() {
    body = Armor.random();
    mainHand = Weapon.random();
  }

  Gear operator +(Gear other) {
    return Gear(
      body: other.body ?? body,
      mainHand: other.mainHand ?? mainHand,
    );
  }
}

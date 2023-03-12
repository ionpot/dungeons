import 'package:dungeons/game/armor.dart';
import 'package:dungeons/game/bonuses.dart';
import 'package:dungeons/game/weapon.dart';
import 'package:dungeons/utility/if.dart';

class Gear {
  Armor? body;
  Weapon? mainHand;
  Weapon? offHand;

  Gear({this.body, this.mainHand, this.offHand});

  int get armor => body?.value ?? 0;

  Bonuses get bonuses {
    final bonuses = Bonuses();
    ifdef(body, bonuses.addArmor);
    ifdef(weaponValue, (value) {
      bonuses.addWeapon(mainHand!, value);
    });
    return bonuses;
  }

  WeaponValue? get weaponValue {
    final group = mainHand?.group;
    if (group == null) {
      return null;
    }
    if (offHand == null) {
      return group.twoHanded ?? group.oneHanded;
    }
    return group.oneHanded;
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

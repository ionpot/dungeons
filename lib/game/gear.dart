import 'package:dungeons/game/armor.dart';
import 'package:dungeons/game/bonus.dart';
import 'package:dungeons/game/bonuses.dart';
import 'package:dungeons/game/weapon.dart';

class Gear {
  Armor? body;
  Weapon? mainHand;
  Weapon? offHand;

  Gear({this.body, this.mainHand, this.offHand});

  int get armor => body?.value ?? 0;

  Bonuses get bonuses {
    return Bonuses({
      if (body != null) Bonus(armor: body): body!.effect,
      if (mainHand != null && weaponValue!.effect != null)
        Bonus(weapon: mainHand): weaponValue!.effect!,
      if (offHand != null) Bonus(offHand: offHand): Weapon.offHandPenalty,
    });
  }

  bool canEquip(Gear gear) {
    if (gear.mainHand != null) {
      if (gear.mainHand!.twoHandOnly) {
        return offHand == null;
      }
    }
    if (gear.offHand != null) {
      if (mainHand != null) {
        return mainHand!.canOneHand;
      }
    }
    return true;
  }

  bool get hasTwoWeapons => mainHand != null && offHand != null;

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

  WeaponValue? get offHandValue => offHand?.group.oneHanded;

  void roll() {
    body = Armor.random();
    mainHand = Weapon.random();
  }

  Gear operator +(Gear other) {
    return Gear(
      body: other.body ?? body,
      mainHand: other.mainHand ?? mainHand,
      offHand: other.offHand ?? offHand,
    );
  }
}

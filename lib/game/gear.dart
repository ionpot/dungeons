import "package:dungeons/game/armor.dart";
import "package:dungeons/game/bonus.dart";
import "package:dungeons/game/bonus_pool.dart";
import "package:dungeons/game/bonus_value.dart";
import "package:dungeons/game/bonuses.dart";
import "package:dungeons/game/weapon.dart";
import "package:dungeons/utility/monoids.dart";

class Gear {
  Armor? body;
  Weapon? mainHand;
  Weapon? offHand;

  Gear({this.body, this.mainHand, this.offHand});

  Bonuses<Int> get armor {
    return Bonuses.fromMap({
      if (body != null) GearBonus.armor(body!): Int(body!.value),
      if (shieldArmor != null) GearBonus.offHand(shield!): Int(shieldArmor!),
    });
  }

  Weapon? get shield => offHand?.group == WeaponGroup.shield ? offHand : null;
  int? get shieldArmor => shield?.offHand?.armor;

  BonusPool get bonuses {
    final pool = BonusPool.empty();
    if (body?.bonus != null) {
      pool.add(GearBonus.armor(body!), body!.bonus!);
    }
    if (shieldArmor != null) {
      pool.add(GearBonus.offHand(shield!), IntBonus.armor(shieldArmor!));
    }
    if (mainHand != null) {
      pool.add(GearBonus.mainHand(mainHand!), weaponValue!.bonus);
    }
    if (offHand != null) {
      pool.add(GearBonus.offHand(offHand!), Weapon.offHandPenalty);
    }
    return pool;
  }

  bool canEquip(Gear gear) {
    if (gear.mainHand != null) {
      if (gear.mainHand!.twoHandOnly) {
        return offHand == null;
      }
    }
    if (gear.offHand != null) {
      if (mainHand != null) {
        return mainHand!.oneHanded;
      }
    }
    return true;
  }

  bool get hasTwoWeapons => mainHand != null && offHandValue?.dice != null;

  WeaponValue? get weaponValue {
    if (offHand != null) {
      return mainHand?.mainHand;
    }
    return mainHand?.twoHanded ?? mainHand?.mainHand;
  }

  WeaponValue? get offHandValue => offHand?.offHand;

  Gear operator +(Gear other) {
    return Gear(
      body: other.body ?? body,
      mainHand: other.mainHand ?? mainHand,
      offHand: other.offHand ?? offHand,
    );
  }

  @override
  int get hashCode => Object.hash(mainHand, offHand, body);

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;
}

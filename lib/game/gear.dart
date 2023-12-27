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
    return Bonuses({
      if (body != null) GearBonus.armor(body!): Int(body!.value),
      if (shield != null) GearBonus.offHand(shield!): Int(shield!.armor!),
    });
  }

  Weapon? get shield => offHand == Weapon.shield ? offHand : null;

  BonusPool get bonuses {
    final pool = BonusPool.empty();
    if (body?.bonus != null) {
      pool.add(GearBonus.armor(body!), body!.bonus!);
    }
    if (shield?.armor != null) {
      pool.add(GearBonus.offHand(shield!), IntBonus.armor(shield!.armor!));
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
        return mainHand!.canOneHand;
      }
    }
    return true;
  }

  bool get hasTwoWeapons => mainHand != null && offHand?.canAttack == true;

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

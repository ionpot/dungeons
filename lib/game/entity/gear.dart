import "package:dungeons/game/entity/armor.dart";
import "package:dungeons/game/entity/aura.dart";
import "package:dungeons/game/entity/bonus.dart";
import "package:dungeons/game/entity/bonus_pool.dart";
import "package:dungeons/game/entity/bonus_value.dart";
import "package:dungeons/game/entity/bonuses.dart";
import "package:dungeons/game/entity/class.dart";
import "package:dungeons/game/entity/weapon.dart";
import "package:dungeons/utility/if.dart";
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

  bool get usingBow => mainHand?.group == WeaponGroup.bow;

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

  bool canEquip(Gear gear, EntityClass klass) {
    final mh = ifdef(gear.mainHand, (weapon) {
      if (klass.canMainHand(weapon)) {
        if (weapon.twoHandOnly) {
          return offHand == null;
        }
        return true;
      }
      return false;
    });
    final oh = ifdef(gear.offHand, (weapon) {
      if (klass.canOffHand(weapon)) {
        if (mainHand != null) {
          return !mainHand!.twoHandOnly;
        }
        return true;
      }
      return false;
    });
    return mh ?? oh ?? true;
  }

  bool get hasTwoWeapons => mainHand != null && offHandValue?.dice != null;

  WeaponValue? get weaponValue {
    if (offHand != null) {
      return mainHand?.mainHand;
    }
    return mainHand?.twoHanded ?? mainHand?.mainHand;
  }

  WeaponValue? get offHandValue => offHand?.offHand;

  Aura? get aura => offHandValue?.aura;

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

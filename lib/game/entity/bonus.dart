import "package:dungeons/game/entity/armor.dart";
import "package:dungeons/game/entity/attributes.dart";
import "package:dungeons/game/entity/aura.dart";
import "package:dungeons/game/entity/class.dart";
import "package:dungeons/game/entity/critical_hit.dart";
import "package:dungeons/game/entity/feat.dart";
import "package:dungeons/game/entity/gear.dart";
import "package:dungeons/game/entity/race.dart";
import "package:dungeons/game/entity/spell.dart";
import "package:dungeons/game/entity/status_effect.dart";
import "package:dungeons/game/entity/weapon.dart";

sealed class Bonus {
  const Bonus();

  bool get stacks => false;

  int get hash;
  String get text;

  @override
  int get hashCode => hash;

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  String toString() => text;
}

final class AttributeBonus extends Bonus {
  final EntityAttributeId? attribute;
  final bool base;

  const AttributeBonus(this.attribute, {required this.base});

  static const baseAttributes = AttributeBonus(null, base: true);
  static const baseStrength =
      AttributeBonus(EntityAttributeId.strength, base: true);
  static const bonusStrength =
      AttributeBonus(EntityAttributeId.strength, base: false);
  static const baseAgility =
      AttributeBonus(EntityAttributeId.agility, base: true);
  static const bonusAgility =
      AttributeBonus(EntityAttributeId.agility, base: false);
  static const baseIntellect =
      AttributeBonus(EntityAttributeId.intellect, base: true);
  static const bonusIntellect =
      AttributeBonus(EntityAttributeId.intellect, base: false);

  @override
  int get hash => Object.hash(attribute, base);

  @override
  String get text {
    if (attribute == null) {
      return "Attributes";
    }
    return base ? "Base $attribute" : "$attribute Bonus";
  }
}

final class ClassBonus extends Bonus {
  final EntityClass? klass;
  final int level;

  const ClassBonus(this.klass, this.level);
  const ClassBonus.level(int level) : this(null, level);

  @override
  int get hash => Object.hash(klass, level);

  @override
  String get text {
    if (klass == null) {
      return "Level $level";
    }
    return "$klass Lv$level";
  }
}

final class RaceBonus extends Bonus {
  final EntityRace race;

  const RaceBonus(this.race);

  @override
  int get hash => race.hashCode;

  @override
  String get text => race.toString();
}

final class CriticalHitBonus extends Bonus {
  final CriticalHit hit;

  const CriticalHitBonus(this.hit);

  @override
  int get hash => hit.hashCode;

  @override
  String get text => hit.toString();
}

final class GearBonus extends Bonus {
  final Gear gear;

  const GearBonus(this.gear);
  GearBonus.mainHand(Weapon weapon) : this(Gear(mainHand: weapon));
  GearBonus.offHand(Weapon weapon) : this(Gear(offHand: weapon));
  GearBonus.armor(Armor armor) : this(Gear(body: armor));

  @override
  int get hash => gear.hashCode;

  @override
  String get text {
    if (gear.offHand != null) {
      return "${gear.offHand} (off-hand)";
    }
    return (gear.mainHand ?? gear.body ?? "").toString();
  }
}

final class FeatBonus extends Bonus {
  final FeatSlot feat;

  const FeatBonus(this.feat);

  @override
  int get hash => feat.hashCode;

  @override
  String get text => feat.toString();
}

final class SpellBonus extends Bonus {
  final Spell spell;

  const SpellBonus(this.spell);

  @override
  bool get stacks => spell.stacks;

  @override
  int get hash => spell.hashCode;

  @override
  String get text => spell.toString();
}

final class EffectBonus extends Bonus {
  final Bonus bonus;
  final StatusEffect effect;

  const EffectBonus(this.bonus, this.effect);

  @override
  int get hash => Object.hash(bonus, effect);

  @override
  String get text => "$effect ($bonus)";
}

final class AuraBonus extends Bonus {
  final Aura aura;

  const AuraBonus(this.aura);

  @override
  int get hash => aura.hashCode;

  @override
  String get text => aura.text;
}

final class OtherBonus extends Bonus {
  @override
  final String text;

  const OtherBonus(this.text);

  @override
  int get hash => text.hashCode;

  static const defending = OtherBonus("Defending");
}

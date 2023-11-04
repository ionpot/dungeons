import 'package:dungeons/game/armor.dart';
import 'package:dungeons/game/critical_hit.dart';
import 'package:dungeons/game/entity_attr.dart';
import 'package:dungeons/game/entity_class.dart';
import 'package:dungeons/game/entity_race.dart';
import 'package:dungeons/game/feat.dart';
import 'package:dungeons/game/spell.dart';
import 'package:dungeons/game/weapon.dart';

class Bonus {
  final bool attributes;
  final int level;
  final EntityAttributeId? baseAttribute;
  final EntityAttributeId? bonusAttribute;
  final EntityRace? race;
  final EntityClass? klass;
  final CriticalHit? criticalHit;
  final Weapon? weapon;
  final Weapon? offHand;
  final Armor? armor;
  final FeatSlot? feat;
  final Spell? spell;

  const Bonus({
    this.attributes = false,
    this.level = 0,
    this.baseAttribute,
    this.bonusAttribute,
    this.race,
    this.klass,
    this.criticalHit,
    this.weapon,
    this.offHand,
    this.armor,
    this.feat,
    this.spell,
  });

  static const baseStrength = Bonus(baseAttribute: EntityAttributeId.strength);
  static const bonusStrength =
      Bonus(bonusAttribute: EntityAttributeId.strength);
  static const baseAgility = Bonus(baseAttribute: EntityAttributeId.agility);
  static const bonusAgility = Bonus(bonusAttribute: EntityAttributeId.agility);
  static const bonusIntellect =
      Bonus(bonusAttribute: EntityAttributeId.intellect);

  factory Bonus.attributes() {
    return const Bonus(attributes: true);
  }

  bool get stacks => spell?.stacks == true;

  @override
  bool operator ==(dynamic other) => hashCode == other.hashCode;

  @override
  int get hashCode {
    return Object.hash(
      attributes,
      level,
      baseAttribute,
      bonusAttribute,
      race,
      klass,
      criticalHit,
      weapon,
      offHand,
      armor,
      feat,
      spell,
    );
  }

  @override
  String toString() {
    if (attributes) {
      return 'Attributes';
    }
    if (baseAttribute != null) {
      return 'Base ${baseAttribute!.text}';
    }
    if (bonusAttribute != null) {
      return '${bonusAttribute!.text} Bonus';
    }
    if (level > 0 && klass != null) {
      return '$klass Lv$level';
    }
    if (level > 0) {
      return 'Level $level';
    }
    if (offHand != null) {
      return '$offHand (off-hand)';
    }
    return race?.text ??
        klass?.text ??
        criticalHit?.toString() ??
        weapon?.text ??
        armor?.text ??
        feat?.toString() ??
        spell?.text ??
        '';
  }
}

typedef BonusMap<T extends Object> = Map<Bonus, T>;

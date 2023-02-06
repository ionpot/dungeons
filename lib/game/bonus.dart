import 'package:dungeons/game/armor.dart';
import 'package:dungeons/game/effect.dart';
import 'package:dungeons/game/entity_attr.dart';
import 'package:dungeons/game/feat.dart';
import 'package:dungeons/game/spell.dart';
import 'package:dungeons/game/weapon.dart';

class Bonus {
  final EntityAttributeId? attribute;
  final Weapon? weapon;
  final Armor? armor;
  final Feat? feat;
  final Spell? spell;

  const Bonus({this.attribute, this.weapon, this.armor, this.feat, this.spell});

  factory Bonus.agility() => const Bonus(attribute: EntityAttributeId.agility);

  Effect? get effect {
    return weapon?.effect ?? armor?.effect ?? feat?.effect ?? spell?.effect;
  }

  int? get reservedStress => feat?.reserveStress ?? spell?.reserveStress;

  bool get stacks => spell?.stacks == true;

  @override
  bool operator ==(dynamic other) {
    return other is Bonus &&
        attribute == other.attribute &&
        weapon == other.weapon &&
        armor == other.armor &&
        feat == other.feat &&
        spell == other.spell;
  }

  @override
  int get hashCode => Object.hash(attribute, weapon, armor, feat, spell);

  @override
  String toString() {
    return attribute?.text ??
        weapon?.text ??
        armor?.text ??
        feat?.text ??
        spell?.text ??
        '';
  }
}

typedef BonusMap<T extends Object> = Map<Bonus, T>;

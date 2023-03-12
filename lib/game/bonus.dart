import 'package:dungeons/game/armor.dart';
import 'package:dungeons/game/critical_hit.dart';
import 'package:dungeons/game/entity_attr.dart';
import 'package:dungeons/game/feat.dart';
import 'package:dungeons/game/spell.dart';
import 'package:dungeons/game/weapon.dart';

class Bonus {
  final EntityAttributeId? attribute;
  final CriticalHit? criticalHit;
  final Weapon? weapon;
  final Armor? armor;
  final FeatSlot? feat;
  final Spell? spell;

  const Bonus({
    this.attribute,
    this.criticalHit,
    this.weapon,
    this.armor,
    this.feat,
    this.spell,
  });

  factory Bonus.agility() => const Bonus(attribute: EntityAttributeId.agility);

  bool get stacks => spell?.stacks == true;

  @override
  bool operator ==(dynamic other) => hashCode == other.hashCode;

  @override
  int get hashCode {
    return Object.hash(
      attribute,
      criticalHit,
      weapon,
      armor,
      feat,
      spell,
    );
  }

  @override
  String toString() {
    return attribute?.text ??
        criticalHit?.toString() ??
        weapon?.text ??
        armor?.text ??
        feat?.toString() ??
        spell?.text ??
        '';
  }
}

typedef BonusMap<T extends Object> = Map<Bonus, T>;

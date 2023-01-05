import 'package:dungeons/game/armor.dart';
import 'package:dungeons/game/effect_bonus.dart';
import 'package:dungeons/game/skill.dart';
import 'package:dungeons/game/spell.dart';
import 'package:dungeons/game/weapon.dart';

class Effect {
  final Weapon? weapon;
  final Armor? armor;
  final Skill? skill;
  final Spell? spell;

  const Effect({this.weapon, this.armor, this.skill, this.spell});

  EffectBonus? get bonus {
    return weapon?.bonus ?? armor?.bonus ?? skill?.bonus ?? spell?.effect;
  }

  int? get reservedStress => skill?.reserveStress ?? spell?.reserveStress;

  bool get stacks => spell?.stacks == true;

  @override
  bool operator ==(dynamic other) {
    return other is Effect &&
        weapon == other.weapon &&
        armor == other.armor &&
        skill == other.skill &&
        spell == other.spell;
  }

  @override
  int get hashCode => Object.hash(weapon, armor, skill, spell);
}

typedef EffectMap<T extends Object> = Map<Effect, T>;

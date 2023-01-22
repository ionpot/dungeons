import 'package:dungeons/game/armor.dart';
import 'package:dungeons/game/effect_bonus.dart';
import 'package:dungeons/game/feat.dart';
import 'package:dungeons/game/spell.dart';
import 'package:dungeons/game/weapon.dart';

class Effect {
  final Weapon? weapon;
  final Armor? armor;
  final Feat? feat;
  final Spell? spell;

  const Effect({this.weapon, this.armor, this.feat, this.spell});

  EffectBonus? get bonus {
    return weapon?.bonus ?? armor?.bonus ?? feat?.bonus ?? spell?.effect;
  }

  int? get reservedStress => feat?.reserveStress ?? spell?.reserveStress;

  bool get stacks => spell?.stacks == true;

  @override
  bool operator ==(dynamic other) {
    return other is Effect &&
        weapon == other.weapon &&
        armor == other.armor &&
        feat == other.feat &&
        spell == other.spell;
  }

  @override
  int get hashCode => Object.hash(weapon, armor, feat, spell);

  @override
  String toString() {
    return weapon?.text ?? armor?.text ?? feat?.text ?? spell?.text ?? '';
  }
}

typedef EffectMap<T extends Object> = Map<Effect, T>;

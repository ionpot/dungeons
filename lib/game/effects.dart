import 'package:dungeons/game/armor.dart';
import 'package:dungeons/game/effect_bonus.dart';
import 'package:dungeons/game/skill.dart';
import 'package:dungeons/game/spell.dart';
import 'package:dungeons/game/weapon.dart';
import 'package:dungeons/utility/if.dart';
import 'package:dungeons/utility/percent.dart';

class Effect {
  final Weapon? weapon;
  final Armor? armor;
  final Skill? skill;
  final Spell? spell;

  const Effect({this.weapon, this.armor, this.skill, this.spell});

  EffectBonus? get bonus {
    if (weapon != null) return weapon!.bonus;
    if (armor != null) return armor!.bonus;
    if (skill != null) return skill!.bonus;
    if (spell != null) return spell!.effect;
    return null;
  }

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

typedef GetEffectBonus<T extends Object> = T? Function(EffectBonus);

class Effects {
  final Set<Effect> contents = {};

  Effects();

  List<EffectBonus> get bonuses {
    final ls = <EffectBonus>[];
    for (final effect in contents) {
      ifdef(effect.bonus, ls.add);
    }
    return ls;
  }

  int get reservedStress {
    int sum = 0;
    for (final effect in contents) {
      sum += effect.skill?.reserveStress ?? 0;
    }
    return sum;
  }

  bool has(Effect effect) => contents.contains(effect);

  void add(Effect effect) {
    contents.add(effect);
  }

  void remove(Effect effect) {
    contents.remove(effect);
  }

  int sumInt(GetEffectBonus<int> f) {
    int sum = 0;
    for (final bonus in bonuses) {
      sum += f(bonus) ?? 0;
    }
    return sum;
  }

  Percent sumPercent(GetEffectBonus<Percent> f) {
    var sum = const Percent();
    for (final bonus in bonuses) {
      ifdef(f(bonus), (p) => sum += p);
    }
    return sum;
  }
}

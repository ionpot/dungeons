import 'package:dungeons/game/armor.dart';
import 'package:dungeons/game/effect_bonus.dart';
import 'package:dungeons/game/skill.dart';
import 'package:dungeons/game/weapon.dart';
import 'package:dungeons/utility/percent.dart';

class Effect {
  final Weapon? weapon;
  final Armor? armor;
  final Skill? skill;

  const Effect({this.weapon, this.armor, this.skill});

  EffectBonus get bonus {
    if (weapon != null) return weapon!.bonus;
    if (armor != null) return armor!.bonus;
    if (skill != null) return skill!.bonus;
    throw Exception('Effect is null.');
  }

  @override
  bool operator ==(dynamic other) {
    return other is Effect &&
        weapon == other.weapon &&
        armor == other.armor &&
        skill == other.skill;
  }

  @override
  int get hashCode => Object.hash(weapon, armor, skill);
}

typedef GetEffectBonus<T extends Object> = T? Function(EffectBonus);

class Effects {
  final Set<Effect> contents = {};

  Effects();

  bool has(Effect effect) => contents.contains(effect);

  void add(Effect effect) {
    contents.add(effect);
  }

  void remove(Effect effect) {
    contents.remove(effect);
  }

  int sumInt(GetEffectBonus<int> f) {
    int sum = 0;
    for (final effect in contents) {
      sum += f(effect.bonus) ?? 0;
    }
    return sum;
  }

  Percent sumPercent(GetEffectBonus<Percent> f) {
    var sum = const Percent();
    for (final effect in contents) {
      final s = f(effect.bonus);
      if (s != null) sum += s;
    }
    return sum;
  }
}

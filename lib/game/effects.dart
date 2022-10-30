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

  bool equals(Effect e) {
    if (weapon != null) return weapon == e.weapon;
    if (armor != null) return armor == e.armor;
    if (skill != null) return skill == e.skill;
    throw Exception('Effect is null.');
  }
}

typedef GetEffectBonus<T extends Object> = T? Function(EffectBonus);

class Effects {
  final List<Effect> list = [];

  Effects();

  bool has(Effect effect) {
    return list.any((e) => e.equals(effect));
  }

  void add(Effect effect) {
    list.add(effect);
  }

  void remove(Effect effect) {
    list.removeWhere((e) => e.equals(effect));
  }

  int sumInt(GetEffectBonus<int> f) {
    int sum = 0;
    for (final effect in list) {
      sum += f(effect.bonus) ?? 0;
    }
    return sum;
  }

  Percent sumPercent(GetEffectBonus<Percent> f) {
    var sum = const Percent();
    for (final effect in list) {
      final s = f(effect.bonus);
      if (s != null) sum += s;
    }
    return sum;
  }
}

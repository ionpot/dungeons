import 'package:dungeons/game/armor.dart';
import 'package:dungeons/game/effect_bonus.dart';
import 'package:dungeons/game/skill.dart';
import 'package:dungeons/game/weapon.dart';
import 'package:dungeons/utility/percent.dart';

class EffectSource {
  final Weapon? weapon;
  final Armor? armor;
  final Skill? skill;

  const EffectSource({this.weapon, this.armor, this.skill});

  bool equals(EffectSource e) {
    if (weapon != null) return weapon == e.weapon;
    if (armor != null) return armor == e.armor;
    if (skill != null) return skill == e.skill;
    throw Exception('Effect source can\'t be all null.');
  }
}

class Effect {
  final EffectSource source;
  final EffectBonus bonus;

  const Effect(this.source, this.bonus);
}

typedef GetEffectBonus<T extends Object> = T? Function(EffectBonus);

class Effects {
  final List<Effect> list = [];

  Effects();

  bool has(EffectSource source) {
    return list.any((e) => e.source.equals(source));
  }

  void add(EffectSource source, EffectBonus bonus) {
    list.add(Effect(source, bonus));
  }

  void remove(EffectSource source) {
    list.removeWhere((e) => e.source.equals(source));
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

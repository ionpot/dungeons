import 'package:dungeons/game/armor.dart';
import 'package:dungeons/game/effect.dart';
import 'package:dungeons/game/effect_bonus.dart';
import 'package:dungeons/game/skill.dart';
import 'package:dungeons/game/spell.dart';
import 'package:dungeons/game/weapon.dart';
import 'package:dungeons/utility/if.dart';
import 'package:dungeons/utility/percent.dart';

typedef GetEffectBonus<T extends Object> = T? Function(EffectBonus);

class Effects {
  final Map<Effect, EffectBonus> contents = {};

  Effects();

  int get reservedStress {
    int sum = 0;
    for (final effect in contents.keys) {
      sum += effect.reservedStress ?? 0;
    }
    return sum;
  }

  bool has(Effect effect) => contents.containsKey(effect);

  void add(Effect effect) {
    final bonus = effect.bonus ?? const EffectBonus();
    if (effect.stacks) {
      contents.update(
        effect,
        (b) => b + bonus,
        ifAbsent: () => bonus,
      );
    } else {
      contents[effect] = bonus;
    }
  }

  void remove(Effect effect) => contents.remove(effect);

  void addWeapon(Weapon weapon) => add(Effect(weapon: weapon));
  void removeWeapon(Weapon weapon) => remove(Effect(weapon: weapon));

  void addArmor(Armor armor) => add(Effect(armor: armor));
  void removeArmor(Armor armor) => remove(Effect(armor: armor));

  void addSkill(Skill skill) => add(Effect(skill: skill));
  bool hasSkill(Skill skill) => has(Effect(skill: skill));

  void addSpell(Spell spell) => add(Effect(spell: spell));
  bool hasSpell(Spell spell) => has(Effect(spell: spell));

  void clearSpells() {
    contents.removeWhere((key, value) => key.spell != null);
  }

  Effect? findEffect(GetEffectBonus<bool> f) {
    for (final entry in contents.entries) {
      if (f(entry.value) == true) {
        return entry.key;
      }
    }
    return null;
  }

  IntEffects toIntEffects(GetEffectBonus<int> f) {
    final EffectMap<int> map = {};
    for (final entry in contents.entries) {
      ifdef(f(entry.value), (value) {
        map[entry.key] = value;
      });
    }
    return IntEffects(map);
  }

  PercentEffects toPercentEffects(GetEffectBonus<Percent> f) {
    final EffectMap<Percent> map = {};
    for (final entry in contents.entries) {
      ifdef(f(entry.value), (value) {
        map[entry.key] = value;
      });
    }
    return PercentEffects(map);
  }
}

class IntEffects {
  final EffectMap<int> contents;

  const IntEffects([this.contents = const {}]);

  int get total => contents.values.fold(0, (sum, value) => sum + value);

  void add(Effect effect, int value) {
    contents[effect] = value;
  }
}

class PercentEffects {
  final EffectMap<Percent> contents;

  const PercentEffects([this.contents = const {}]);

  bool get isEmpty => contents.isEmpty;

  Percent get total {
    return contents.values.fold(
      const Percent(),
      (sum, value) => sum + value,
    );
  }
}

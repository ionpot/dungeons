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

  bool sumBool(GetEffectBonus<bool> f) {
    for (final bonus in contents.values) {
      if (f(bonus) == true) {
        return true;
      }
    }
    return false;
  }

  int sumInt(GetEffectBonus<int> f) {
    int sum = 0;
    for (final bonus in contents.values) {
      sum += f(bonus) ?? 0;
    }
    return sum;
  }

  Percent sumPercent(GetEffectBonus<Percent> f) {
    var sum = const Percent();
    for (final bonus in contents.values) {
      ifdef(f(bonus), (p) => sum += p);
    }
    return sum;
  }
}

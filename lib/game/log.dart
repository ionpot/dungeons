import 'dart:io';

import 'package:dungeons/game/combat.dart';
import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/source.dart';
import 'package:dungeons/game/spell_cast.dart';
import 'package:dungeons/game/value.dart';
import 'package:dungeons/game/weapon_attack.dart';
import 'package:dungeons/utility/dice.dart';
import 'package:dungeons/utility/if.dart';

class Log {
  final IOSink file;

  Log(this.file);
  Log.toFile(String name) : this(File(name).openWrite());

  void ln() => file.writeln();

  Future<void> end() async {
    await file.flush();
    await file.close();
  }

  void entity(Entity e) {
    final damage = e.weaponDamage;
    file
      ..writeln('${e.name}, ${e.race} ${e.klass} Lv${e.level}')
      ..writeln('${e.attributes}')
      ..writeln('Hp ${e.totalHp}'
          '${e.player ? ', Stress Cap ${e.stressCap}' : ''}'
          '${e.player ? ', XP ${e.toXpString()}' : ''}')
      ..writeln('Initiative ${e.initiative}')
      ..writeln('Dodge ${e.dodge}, Resist ${e.resist}')
      ..writeln('Armor: ${e.armor} (${e.totalArmor})')
      ..writeln('Weapon: ${e.weapon} ($damage) ${damage?.range}');
  }

  void combatTurn(CombatTurn turn) {
    ifdef(turn.weaponTurn, weaponTurn);
    ifdef(turn.spellTurn, spellTurn);
  }

  void weaponTurn(WeaponAttackTurn turn) {
    final attack = turn.attack;
    final result = turn.result;
    final attacker = attack.attacker;
    final target = attack.target;
    final weapon = attacker.weapon!.text;
    file
      ..writeln('$attacker attacks $target with $weapon.')
      ..writeln('Attack roll ${_percentRoll(result.attackRoll)}');
    if (result.deflected) {
      file.writeln('$target deflects the attack.');
      return;
    }
    file.writeln('Dodge roll ${_percentRoll(result.dodgeRoll)}');
    if (result.dodged) {
      file.writeln('$target dodges the attack.');
      return;
    }
    _writeDiceRolls(weapon, result.damageRoll);
    _writeDamage(target, result.damageRoll, attack.source);
    _writeStatus(target);
  }

  void spellTurn(SpellCastTurn turn) {
    final cast = turn.cast;
    final result = turn.result;
    final caster = cast.caster;
    final target = cast.target;
    final spell = cast.spell;
    file
      ..write('$caster casts $spell ')
      ..writeln(cast.self ? 'to self.' : 'at $target.');
    if (result.canResist) {
      file.writeln('Resist ${_percentRoll(result.resistRoll)}');
    }
    if (result.resisted) {
      file.writeln('$target resists the spell.');
      return;
    }
    ifdef(result.healRoll, (healRoll) {
      _writeDiceRolls(spell.text, healRoll);
      file.writeln('$target is healed by $healRoll.');
    });
    ifdef(result.damageRoll, (damageRoll) {
      _writeDiceRolls(spell.text, damageRoll);
      _writeDamage(target, damageRoll, spell.source);
      _writeStatus(target, turn);
    });
  }

  void newRound(int round) {
    file.writeln('Round $round');
  }

  void xpGain(Combat combat) {
    file.writeln('${combat.player} gains ${combat.xpGain} XP'
        '${combat.canLevelUp() ? ', and levels up' : ''}.');
  }

  String _percentRoll(PercentValueRoll roll) {
    return '(${roll.input}) ${roll.result}';
  }

  void _writeDamage(Entity target, DiceRollValue damage, Source source) {
    file.write('$target takes $damage ${source.name} damage');
  }

  void _writeDiceRoll(String name, DiceRoll value) {
    file.writeln('$name roll (${value.dice.base}) $value');
  }

  void _writeDiceRolls(String rollName, DiceRollValue value) {
    _writeDiceRoll(rollName, value.base);
    for (final entry in value.diceBonuses.contents.entries) {
      _writeDiceRoll('${entry.key}', entry.value);
    }
  }

  void _writeStatus(Entity target, [SpellCastTurn? spellTurn]) {
    if (target.dead) {
      file.write(', and dies');
    } else if (spellTurn?.result.didEffect == true) {
      ifdef(spellTurn?.cast.spell.effectText, (text) {
        file.write(', and $text');
      });
    }
    file.writeln('.');
  }
}

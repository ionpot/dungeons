import 'dart:io';

import 'package:dungeons/game/combat.dart';
import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/source.dart';
import 'package:dungeons/game/spell.dart';
import 'package:dungeons/game/spell_cast.dart';
import 'package:dungeons/game/value.dart';
import 'package:dungeons/game/weapon_attack.dart';
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
    final from = attack.from;
    final target = attack.target;
    file
      ..writeln(
        '${from.name} attacks ${target.name} with ${from.weapon}.',
      )
      ..writeln('Attack roll ${_percentRoll(result.hit)}');
    if (result.hit.fail) {
      file.writeln('${target.name} deflects the attack.');
      return;
    }
    if (result.dodge != null) {
      file.writeln('Dodge roll ${_percentRoll(result.dodge!)}');
      if (result.dodge!.success) {
        file.writeln('${target.name} dodges the attack.');
        return;
      }
    }
    if (result.sneakDamage != null) {
      file.writeln(
        'Sneak attack (${attack.sneakDamage}) ${result.sneakDamage}',
      );
    }
    if (result.damage != null) {
      _writeDamage(target, result.damage!, attack.source);
      _writeStatus(target);
      return;
    }
  }

  void spellTurn(SpellCastTurn turn) {
    final attack = turn.attack;
    final result = turn.result;
    final from = attack.from;
    final target = attack.target;
    final spell = attack.spell;
    file
      ..write('${from.name} casts $spell ')
      ..writeln(attack.self ? 'to self.' : 'at ${target.name}.');
    if (result.resist != null) {
      file.writeln('Resist ${_percentRoll(result.resist!)}');
    }
    if (result.heal != null) {
      file.writeln('Heal roll (${spell.heals}) ${result.healDice}');
      file.writeln('${target.name} is healed by ${result.heal}.');
    }
    if (result.damage != null) {
      file.writeln('Damage roll (${spell.damage}) ${result.damageDice}');
      _writeDamage(target, result.damage!, spell.source);
      _writeStatus(target, turn);
    }
  }

  void newRound(int round) {
    file.writeln('Round $round');
  }

  void xpGain(Combat combat) {
    file.writeln('${combat.player.name} gains ${combat.xpGain} XP'
        '${combat.canLevelUp() ? ', and levels up' : ''}.');
  }

  String _percentRoll(PercentValueRoll roll) {
    return '(${roll.input}) ${roll.result}';
  }

  void _writeDamage(Entity target, IntValue damage, Source source) {
    file.write('${target.name} takes $damage ${source.name} damage');
  }

  void _writeStatus(Entity target, [SpellCastTurn? spellTurn]) {
    if (target.dead) {
      file.write(', and dies');
    } else if (spellTurn?.result.affected == true) {
      if (spellTurn?.attack.spell == Spell.rayOfFrost) {
        file.write(', and is slowed');
      }
    }
    file.writeln('.');
  }
}

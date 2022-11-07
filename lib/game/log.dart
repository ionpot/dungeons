import 'dart:io';

import 'package:dungeons/game/combat.dart';
import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/spell.dart';
import 'package:dungeons/game/spell_attack.dart';
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
    file
      ..writeln('${e.name}, ${e.race.text} ${e.klass?.text} Lv${e.level}')
      ..writeln('${e.attributes}')
      ..writeln('Hp ${e.totalHp}'
          '${e.player ? ', Stress Cap ${e.stress.cap}' : ''}'
          '${e.player ? ', XP ${e.toXpString()}' : ''}')
      ..writeln('Initiative ${e.initiative}')
      ..writeln('Dodge ${e.dodge}, Resist ${e.resist}')
      ..writeln('Armor: ${e.armor?.text} (${e.totalArmor})')
      ..writeln('Weapon: ${e.weapon?.text} (${e.damage}) ${e.damage?.range}');
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
        '${from.name} attacks ${target.name} with ${from.weapon?.text}.',
      )
      ..writeln('Attack roll (${attack.hitChance}) ${result.hit}');
    if (result.hit.fail) {
      file.writeln('${target.name} deflects the attack.');
      return;
    }
    if (result.dodge != null) {
      file.writeln('Dodge roll (${attack.dodgeChance}) ${result.dodge}');
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
      file.write('${target.name} takes ${result.damage} damage');
      _writeStatus(target);
      return;
    }
  }

  void spellTurn(SpellAttackTurn turn) {
    final attack = turn.attack;
    final result = turn.result;
    final from = attack.from;
    final target = attack.target;
    final spell = attack.spell;
    file.writeln('${from.name} casts ${spell.text} at ${target.name}');
    if (!spell.autoHit) {
      file.writeln('Resist (${attack.resistChance}) ${result.resist}');
    }
    if (result.damageRoll != null) {
      file.write('${target.name} takes ${result.damageRoll!.total} damage');
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

  void _writeStatus(Entity target, [SpellAttackTurn? spellTurn]) {
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

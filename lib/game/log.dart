import 'dart:io';

import 'package:dungeons/game/attack.dart';
import 'package:dungeons/game/entity.dart';

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

  void attack(Attack a, AttackResult result) {
    final from = a.from;
    final target = a.target;
    file
      ..writeln(
        '${from.name} attacks ${target.name} with ${from.weapon?.text}.',
      )
      ..writeln('Attack roll (${a.hitChance}) ${result.hit}');
    if (result.hit.fail) {
      file.writeln('${target.name} deflects the attack.');
      return;
    }
    if (result.dodge != null) {
      file.writeln('Dodge roll (${a.dodgeChance}) ${result.dodge}');
      if (result.dodge!.success) {
        file.writeln('${target.name} dodges the attack.');
        return;
      }
    }
    if (result.sneakDamage != null) {
      file.writeln('Sneak attack (${a.sneakDamage}) ${result.sneakDamage}');
    }
    if (result.damage != null) {
      file.writeln('${target.name} takes ${result.damage} damage'
          '${target.dead ? ', and dies' : ''}.');
      return;
    }
  }

  void newRound(int round) {
    file.writeln('Round $round');
  }
}

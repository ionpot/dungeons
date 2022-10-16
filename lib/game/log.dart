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
      ..writeln(e.name)
      ..writeln('${e.race.text} ${e.klass?.text} Lv${e.level}: ${e.attributes}')
      ..writeln('Hp ${e.totalHp}, Initiative ${e.initiative},'
          ' Stress Cap ${e.stressCap}')
      ..writeln('Dodge ${e.dodge}, Resist ${e.resist}')
      ..writeln('Armor: ${e.armor?.text} (${e.totalArmor})')
      ..writeln('Weapon: ${e.weapon?.text} ${e.damageDice?.fullText}');
  }

  void attack(Attack a) {
    final from = a.from;
    final target = a.target;
    file
      ..writeln(
          '${from.name} attacks ${target.name} with ${from.weapon?.text}.')
      ..writeln('Attack roll ${a.roll}');
    if (a.roll.fail) {
      file.writeln('${target.name} deflects the attack.');
      return;
    }
    if (a.dodge != null) {
      file.writeln('Dodge roll ${a.dodge}');
      if (a.dodge!.success) {
        file.writeln('${target.name} dodges the attack.');
        return;
      }
    }
    if (a.damage != null) {
      file.writeln('${target.name} takes ${a.damage} damage'
          '${target.dead ? ', and dies' : ''}.');
      return;
    }
  }

  void newRound(int round) {
    file.writeln('Round $round');
  }
}

import 'dart:io';

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
      ..writeln('${e.race.text} ${e.klass?.text}: ${e.attributes}')
      ..writeln('Hp ${e.totalHp}, Init ${e.initiative}, '
          'Dodge ${e.dodge}, Resist ${e.resist}')
      ..writeln('Armor: ${e.armor?.text} (${e.totalArmor})')
      ..writeln('Weapon: ${e.weapon?.text} ${e.damageDice?.fullText}');
  }
}

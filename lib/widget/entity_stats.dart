import 'package:dungeons/game/entity.dart';
import 'package:dungeons/widget/text_lines.dart';
import 'package:flutter/widgets.dart';

class EntityStats extends StatelessWidget {
  final Entity entity;

  const EntityStats(this.entity, {super.key});

  @override
  Widget build(BuildContext context) {
    final e = entity;
    return TextLines([
      e.name,
      '${e.race.text} ${e.klass?.text}: ${e.attributes}',
      'Hp ${e.hp}/${e.totalHp}, Init ${e.initiative},'
          ' Dodge ${e.dodge}, Resist ${e.resist}',
      'Armor: ${e.armor?.text} (${e.totalArmor})',
      'Weapon: ${e.weapon?.text} ${e.damageDice?.fullText}',
    ]);
  }
}

import 'package:dungeons/game/entity.dart';
import 'package:flutter/widgets.dart';

class EntityStats extends StatelessWidget {
  final Entity entity;

  const EntityStats(this.entity, {super.key});

  @override
  Widget build(BuildContext context) {
    final e = entity;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(e.name),
        Text('${e.race.text} ${e.klass?.text}: ${e.attributes.text}'),
        Text('Hp ${e.totalHp}, Init ${e.initiative},'
            ' Dodge ${e.dodge.text}, Resist ${e.resist.text}'),
        Text('Armor: ${e.armor?.text} (${e.totalArmor})'),
        Text('Weapon: ${e.weapon?.text} ${e.damageDice?.fullText}'),
      ],
    );
  }
}

import 'package:dungeons/game/entity.dart';
import 'package:dungeons/widget/section.dart';
import 'package:flutter/widgets.dart';

class CombatScreen extends StatelessWidget {
  final Entity player;

  const CombatScreen({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return Section.below(
      left: 30,
      child: _buildEntityStats(player),
    );
  }

  Widget _buildEntityStats(Entity e) {
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

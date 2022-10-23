import 'package:dungeons/game/entity.dart';
import 'package:dungeons/widget/colored_text.dart';
import 'package:dungeons/widget/text_lines.dart';
import 'package:flutter/widgets.dart';

class EntityStats extends StatelessWidget {
  final Entity entity;

  const EntityStats(this.entity, {super.key});

  @override
  Widget build(BuildContext context) {
    final e = entity;
    return TextLines([
      Text(e.name),
      Text('${e.race.text} ${e.klass?.text} Lv${e.level}: ${e.attributes}'),
      _hpInitiativeStress,
      _dodgeResist,
      Text('Armor: ${e.armor?.text} (${e.totalArmor})'),
      Text('Weapon: ${e.weapon?.text} ${e.damageDice?.fullText}'),
    ]);
  }

  Widget get _hpInitiativeStress {
    final e = entity;
    return RichText(
      text: TextSpan(children: [
        TextSpan(text: 'Hp ${e.hp}/${e.totalHp}'),
        const TextSpan(text: ', Initiative '),
        coloredIntSpan(e.initiative),
        TextSpan(text: ', Stress ${e.stress.current}/'),
        coloredStressCapSpan(e.stress),
      ]),
    );
  }

  Widget get _dodgeResist {
    final e = entity;
    return RichText(
      text: TextSpan(children: [
        const TextSpan(text: 'Dodge '),
        coloredPercentSpan(e.dodge),
        TextSpan(text: ', Resist ${e.resist}'),
      ]),
    );
  }
}

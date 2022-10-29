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
      Text('${e.name}, ${e.race.text} ${e.klass?.text} Lv${e.level}'),
      Text('${e.attributes}'),
      _hpStressXp,
      _initiative,
      _dodgeResist,
      Text('Armor: ${e.armor?.text} (${e.totalArmor})'),
      Text('Weapon: ${e.weapon?.text} (${e.damage}) ${e.damage?.range}'),
    ]);
  }

  Widget get _hpStressXp {
    final e = entity;
    return RichText(
      text: TextSpan(children: [
        TextSpan(text: 'Hp ${e.hp}/${e.totalHp}'),
        if (e.player) TextSpan(text: ', Stress ${e.stress.current}/'),
        if (e.player) coloredStressCapSpan(e.stress),
        if (e.player) TextSpan(text: ', XP ${e.toXpString()}'),
      ]),
    );
  }

  Widget get _initiative {
    return RichText(
      text: TextSpan(
        children: [
          const TextSpan(text: 'Initiative '),
          coloredIntSpan(entity.initiative),
        ],
      ),
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

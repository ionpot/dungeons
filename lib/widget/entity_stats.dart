import 'package:dungeons/game/entity.dart';
import 'package:dungeons/widget/text_lines.dart';
import 'package:dungeons/widget/value_span.dart';
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
      _weapon,
    ]);
  }

  Widget get _hpStressXp {
    final e = entity;
    return RichText(
      text: TextSpan(children: [
        TextSpan(text: 'Hp ${e.hp}/${e.totalHp}'),
        if (e.player)
          TextSpan(children: [
            const TextSpan(text: ', Stress '),
            StressSpan(e.stress),
            TextSpan(text: ', XP ${e.toXpString()}'),
          ]),
      ]),
    );
  }

  Widget get _initiative {
    return RichText(
      text: TextSpan(
        children: [
          const TextSpan(text: 'Initiative '),
          IntValueSpan(entity.initiative),
        ],
      ),
    );
  }

  Widget get _dodgeResist {
    final e = entity;
    return RichText(
      text: TextSpan(children: [
        const TextSpan(text: 'Dodge '),
        PercentValueSpan(e.dodge),
        TextSpan(text: ', Resist ${e.resist}'),
      ]),
    );
  }

  Widget get _weapon {
    final damage = entity.damage;
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: 'Weapon: ${entity.weapon?.text} ('),
          if (damage != null) DiceValueSpan(damage),
          TextSpan(text: ') ${damage?.range}'),
        ],
      ),
    );
  }
}

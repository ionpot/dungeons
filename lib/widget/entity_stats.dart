import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/value.dart';
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
      Text('${e.name}, ${e.race} ${e.klass} Lv${e.level}'),
      Text('${e.attributes}'),
      _hpStressXp,
      _initiative,
      _dodgeResist,
      Text('Armor: ${e.armor} (${e.totalArmor})'),
      _weapon,
    ]);
  }

  Widget get _hpStressXp {
    final e = entity;
    return Text.rich(
      TextSpan(children: [
        const TextSpan(text: 'Hp '),
        HpSpan(e),
        if (e.player)
          TextSpan(children: [
            const TextSpan(text: ', Stress '),
            StressSpan(e),
            TextSpan(text: ', XP ${e.toXpString()}'),
          ]),
      ]),
    );
  }

  Widget get _initiative {
    return Text.rich(
      TextSpan(
        children: [
          const TextSpan(text: 'Initiative '),
          IntValueSpan(entity.initiative),
        ],
      ),
    );
  }

  Widget get _dodgeResist {
    final e = entity;
    return Text.rich(
      TextSpan(children: [
        const TextSpan(text: 'Dodge '),
        PercentValueSpan(e.dodge),
        const TextSpan(text: ', Resist '),
        PercentValueSpan(e.resist),
      ]),
    );
  }

  Widget get _weapon {
    final damage = entity.weaponDamage;
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: 'Weapon: ${entity.weapon}'),
          if (damage != null) ..._weaponDamage(damage),
        ],
      ),
    );
  }

  List<TextSpan> _weaponDamage(DiceValue damage) {
    return [
      const TextSpan(text: ' ('),
      DiceValueSpan(damage),
      const TextSpan(text: ') '),
      RangeSpan(damage.range, max: damage.max),
    ];
  }
}

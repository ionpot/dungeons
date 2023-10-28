import 'package:dungeons/game/entity.dart';
import 'package:dungeons/utility/if.dart';
import 'package:dungeons/widget/dice_span.dart';
import 'package:dungeons/widget/int_value.dart';
import 'package:dungeons/widget/percent_value.dart';
import 'package:dungeons/widget/stress.dart';
import 'package:dungeons/widget/text_lines.dart';
import 'package:dungeons/widget/value_span.dart';
import 'package:flutter/widgets.dart';

class EntityStats extends StatelessWidget {
  final Entity entity;
  final bool isPlayer;

  const EntityStats(this.entity, {super.key, required this.isPlayer});

  @override
  Widget build(BuildContext context) {
    return TextLines([
      Text('${entity.name}, ${entity.race} ${entity.klass} Lv${entity.level}'),
      Text('${entity.attributes}'),
      _hpStressXp,
      _initiative,
      _dodgeResist,
      _armor,
      _weapon,
      _damage,
      _offHand,
    ]);
  }

  Widget get _armor {
    return Text.rich(TextSpan(children: [
      const TextSpan(text: 'Armor: '),
      TotalArmorSpan(entity),
      TextSpan(text: ' (${entity.armor})'),
    ]));
  }

  Widget get _hpStressXp {
    return Text.rich(
      TextSpan(children: [
        const TextSpan(text: 'Hp '),
        HpSpan(entity),
        if (isPlayer)
          TextSpan(children: [
            const TextSpan(text: ', Stress '),
            StressSpan(entity),
            TextSpan(text: ', XP ${entity.toXpString()}'),
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
    return Text.rich(
      TextSpan(children: [
        const TextSpan(text: 'Dodge '),
        PercentValueSpan(entity.dodge),
        const TextSpan(text: ', Resist '),
        PercentValueSpan(entity.resist),
      ]),
    );
  }

  Widget get _weapon => Text('Weapon: ${entity.weapon}');

  Widget get _damage {
    final damage = entity.weaponDamage;
    return Text.rich(
      TextSpan(
        children: [
          const TextSpan(text: 'Damage: '),
          if (damage != null) DiceValueWithRangeSpan(damage),
        ],
      ),
    );
  }

  Widget get _offHand {
    final weapon = ifdef(entity.gear.offHand, (offHand) {
      final armor = entity.gear.shield?.armor;
      final dice = entity.gear.offHandValue?.dice;
      return '$offHand (${armor ?? dice})';
    });
    return Text('Off-hand: ${weapon ?? 'None'}');
  }
}

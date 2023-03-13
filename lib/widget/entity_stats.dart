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
      _armor,
      _weapon,
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
          TextSpan(text: 'Weapon: ${entity.weapon} '),
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

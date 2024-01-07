import "package:dungeons/game/entity.dart";
import "package:dungeons/game/log.dart";
import "package:dungeons/widget/dice_span.dart";
import "package:dungeons/widget/entity_span.dart";
import "package:dungeons/widget/text_lines.dart";
import "package:dungeons/widget/value_span.dart";
import "package:flutter/widgets.dart";

class EntityStats extends StatelessWidget {
  final Entity entity;
  final bool isPlayer;

  const EntityStats(this.entity, {super.key, required this.isPlayer});

  @override
  Widget build(BuildContext context) {
    return TextLines([
      Text("${entity.name}, ${entity.race} ${entity.klass} Lv${entity.level}"),
      _attributes,
      _hpStressXp,
      _initiative,
      _dodgeResist,
      _armor,
      _weapon,
      _damage,
      _offHand,
    ]);
  }

  Widget get _attributes {
    return Text.rich(
      TextSpan(children: [
        const TextSpan(text: "Str "),
        ValueSpan(entity.strength),
        const TextSpan(text: ", Agi "),
        ValueSpan(entity.agility),
        const TextSpan(text: ", Int "),
        ValueSpan(entity.intellect),
      ]),
    );
  }

  Widget get _armor {
    return Text.rich(TextSpan(children: [
      const TextSpan(text: "Armor: "),
      ArmorValueSpan(entity.armorValue),
      TextSpan(text: " (${entity.armor})"),
    ]));
  }

  Widget get _hpStressXp {
    return Text.rich(
      TextSpan(children: [
        const TextSpan(text: "Hp "),
        HpSpan(entity),
        if (isPlayer)
          TextSpan(children: [
            const TextSpan(text: ", Stress "),
            StressSpan(entity),
            TextSpan(text: ", XP ${entity.toXpString()}"),
          ]),
      ]),
    );
  }

  Widget get _initiative {
    return Text.rich(
      TextSpan(
        children: [
          const TextSpan(text: "Initiative "),
          ValueSpan(entity.initiative),
        ],
      ),
    );
  }

  Widget get _dodgeResist {
    return Text.rich(
      TextSpan(children: [
        const TextSpan(text: "Dodge "),
        ValueSpan(entity.dodge),
        const TextSpan(text: ", Resist "),
        ValueSpan(entity.resist),
      ]),
    );
  }

  Widget get _weapon => Text("Weapon: ${entity.weapon}");

  Widget get _damage {
    final damage = entity.weaponDamage;
    return Text.rich(
      TextSpan(
        children: [
          const TextSpan(text: "Damage: "),
          if (damage != null) DiceValueWithRangeSpan(damage),
        ],
      ),
    );
  }

  Widget get _offHand {
    return Text("Off-hand: ${Log.offHandText(entity)}");
  }
}

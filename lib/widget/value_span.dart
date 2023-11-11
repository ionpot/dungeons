import "package:dungeons/game/entity.dart";
import "package:dungeons/game/source.dart";
import "package:dungeons/game/spell.dart";
import "package:dungeons/game/value.dart";
import "package:dungeons/widget/colors.dart";
import "package:dungeons/widget/dice_span.dart";
import "package:dungeons/widget/int_value.dart";
import "package:dungeons/widget/tooltip_region.dart";
import "package:dungeons/widget/value_table.dart";
import "package:flutter/widgets.dart";

class DamageSpan extends TextSpan {
  DamageSpan(DiceRollValue damage, Source source)
      : super(
          children: [
            DiceRollValueSpan(damage),
            TextSpan(
              text: " ${source.name}",
              style: TextStyle(color: sourceColor(source)),
            ),
          ],
        );
}

class HpSpan extends TextSpan {
  HpSpan(Entity entity)
      : super(
          children: [
            TextSpan(
              text: "${entity.hp}",
              style: TextStyle(color: hpColor(entity)),
            ),
            const TextSpan(text: "/"),
            IntValueSpan(entity.totalHp),
          ],
        );
}

class SpellNameSpan extends TextSpan {
  SpellNameSpan(Spell spell)
      : super(
          text: spell.text,
          style: TextStyle(color: sourceColor(spell.source)),
        );
}

class TotalArmorSpan extends WidgetSpan {
  TotalArmorSpan(Entity entity, {TextStyle? style})
      : super(child: TotalArmorWidget(entity, style: style));
}

class TotalArmorWidget extends StatelessWidget {
  final Entity entity;
  final TextStyle? style;

  const TotalArmorWidget(this.entity, {super.key, this.style});

  Text get text => Text("${entity.totalArmor}", style: style);

  @override
  Widget build(BuildContext context) {
    final armor = entity.armor;
    final shield = entity.shield;
    if (armor == null && shield == null) {
      return text;
    }
    return TooltipRegion(
      tooltip: ValueTable([
        ValueRow(const Text("Base"), Text("${entity.baseArmor}")),
        if (armor != null) ValueRow(Text("$armor"), Text("+${armor.value}")),
        if (shield != null) ValueRow(Text("$shield"), Text("+${shield.armor}")),
      ]),
      child: text,
    );
  }
}

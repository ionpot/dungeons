import "package:dungeons/game/entity.dart";
import "package:dungeons/game/entity/dice_value.dart";
import "package:dungeons/game/entity/spell.dart";
import "package:dungeons/game/source.dart";
import "package:dungeons/widget/colors.dart";
import "package:dungeons/widget/dice_span.dart";
import "package:dungeons/widget/value_span.dart";
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
            ValueSpan(entity.totalHp),
          ],
        );
}

class StressSpan extends TextSpan {
  StressSpan(Entity entity)
      : super(
          children: [
            TextSpan(text: "${entity.stress}/"),
            ValueSpan(entity.stressCap),
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

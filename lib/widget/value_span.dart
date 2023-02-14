import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/source.dart';
import 'package:dungeons/game/spell.dart';
import 'package:dungeons/game/value.dart';
import 'package:dungeons/widget/colors.dart';
import 'package:dungeons/widget/dice_span.dart';
import 'package:flutter/widgets.dart';

class DamageSpan extends TextSpan {
  DamageSpan(DiceRollValue damage, Source source)
      : super(
          children: [
            DiceRollValueSpan(damage),
            TextSpan(
              text: ' ${source.name}',
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
              text: '${entity.hp}',
              style: TextStyle(color: hpColor(entity)),
            ),
            TextSpan(text: '/${entity.totalHp}'),
          ],
        );
}

class StressSpan extends TextSpan {
  StressSpan(Entity entity)
      : super(
          children: [
            TextSpan(text: '${entity.stress}/'),
            StressCapSpan(entity),
          ],
        );
}

class StressCapSpan extends TextSpan {
  StressCapSpan(Entity entity)
      : super(
          text: '${entity.stressCap}',
          style: TextStyle(color: stressCapColor(entity)),
        );
}

class SpellNameSpan extends TextSpan {
  SpellNameSpan(Spell spell)
      : super(
          text: spell.text,
          style: TextStyle(color: sourceColor(spell.source)),
        );
}

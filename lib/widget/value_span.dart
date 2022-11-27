import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/source.dart';
import 'package:dungeons/game/spell.dart';
import 'package:dungeons/game/value.dart';
import 'package:dungeons/utility/bonus_text.dart';
import 'package:dungeons/utility/dice.dart';
import 'package:dungeons/utility/range.dart';
import 'package:dungeons/widget/colors.dart';
import 'package:flutter/widgets.dart';

class IntSpan extends TextSpan {
  IntSpan(int value)
      : super(
          text: '$value',
          style: TextStyle(color: intColor(value)),
        );
}

class IntValueSpan extends TextSpan {
  IntValueSpan(IntValue value)
      : super(
          text: '$value',
          style: TextStyle(color: intValueColor(value)),
        );
}

class PercentValueSpan extends TextSpan {
  PercentValueSpan(PercentValue value)
      : super(
          text: '$value',
          style: TextStyle(color: percentValueColor(value)),
        );
}

class RangeSpan extends TextSpan {
  RangeSpan(Range range, {bool max = false})
      : super(
          text: '${max ? range.max : range}',
          style: TextStyle(color: max ? green : null),
        );
}

class DiceSpan extends TextSpan {
  DiceSpan(Dice dice, {bool max = false})
      : super(
          text: '${max ? dice.max : dice}',
          style: TextStyle(color: max ? green : null),
        );
}

class DiceValueSpan extends TextSpan {
  DiceValueSpan(DiceValue value, {bool max = false})
      : super(
          children: [
            DiceSpan(value.base, max: max),
            TextSpan(
              text: bonusText(value.bonus.total),
              style: TextStyle(color: diceValueColor(value)),
            ),
          ],
        );
}

class DamageSpan extends TextSpan {
  DamageSpan(IntValue damage, Source source)
      : super(
          children: [
            IntValueSpan(damage),
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
            TextSpan(
              text: '${entity.stressCap}',
              style: TextStyle(color: stressColor(entity)),
            ),
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

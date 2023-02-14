import 'package:dungeons/game/bonus.dart';
import 'package:dungeons/game/value.dart';
import 'package:dungeons/utility/dice.dart';
import 'package:dungeons/widget/bold_text.dart';
import 'package:dungeons/widget/colors.dart';
import 'package:dungeons/widget/int_bonus.dart';
import 'package:dungeons/widget/int_value.dart';
import 'package:dungeons/widget/range_span.dart';
import 'package:dungeons/widget/tooltip_region.dart';
import 'package:flutter/widgets.dart';

class DiceRollSpan extends TextSpan {
  DiceRollSpan(DiceRoll value) : super(text: '(${value.dice.base}) $value');
}

class DiceBonusSpan extends WidgetSpan {
  DiceBonusSpan({required Bonus bonus, required Dice dice, TextStyle? style})
      : super(
          child: TooltipRegion(
            content: Text('$bonus'),
            child: Text(
              '+$dice',
              style: const TextStyle(color: green).merge(style),
            ),
          ),
        );
}

class DiceValueSpan extends TextSpan {
  DiceValueSpan(DiceValue value, {TextStyle? style})
      : super(
          children: [
            IntValueSpan(value.diceCountValue, style: style),
            TextSpan(text: value.base.base.sideText, style: style),
            for (final entry in value.diceBonuses.contents.entries)
              DiceBonusSpan(
                bonus: entry.key,
                dice: entry.value,
                style: style,
              ),
            IntBonusSpan(value.intBonusValue, style: style),
          ],
        );
}

class DiceValueWithRangeSpan extends TextSpan {
  DiceValueWithRangeSpan(DiceValue value, {TextStyle? style})
      : super(
          children: [
            TextSpan(text: '(', style: style),
            DiceValueSpan(value, style: style),
            TextSpan(text: ') ', style: style),
            RangeSpan(value.range, max: value.max, style: style),
          ],
        );

  factory DiceValueWithRangeSpan.bold(DiceValue value, {TextStyle? style}) {
    return DiceValueWithRangeSpan(value, style: BoldText.style.merge(style));
  }
}

class DiceRollValueSpan extends WidgetSpan {
  DiceRollValueSpan(DiceRollValue value, {TextStyle? style})
      : super(child: IntValueWidget(value.intValue, style: style));
}

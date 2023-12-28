import "package:dungeons/game/bonus.dart";
import "package:dungeons/game/bonus_entry.dart";
import "package:dungeons/game/dice_bonuses.dart";
import "package:dungeons/game/dice_value.dart";
import "package:dungeons/utility/dice.dart";
import "package:dungeons/utility/monoids.dart";
import "package:dungeons/widget/colors.dart";
import "package:dungeons/widget/compare_bonus.dart";
import "package:dungeons/widget/range_span.dart";
import "package:dungeons/widget/tooltip_region.dart";
import "package:dungeons/widget/value_span.dart";
import "package:flutter/widgets.dart";

class DiceRollSpan extends TextSpan {
  DiceRollSpan(DiceRoll value) : super(text: "(${value.dice.base}) $value");
}

class DiceBonusSpan extends WidgetSpan {
  DiceBonusSpan({
    required Bonus bonus,
    required Dice dice,
    bool noColor = false,
    TextStyle? style,
  }) : super(
          child: TooltipRegion(
            tooltip: Text("$bonus"),
            child: Text(
              "+$dice",
              style: TextStyle(color: noColor ? null : green).merge(style),
            ),
          ),
        );
}

class DiceValueSpan extends TextSpan {
  DiceValueSpan(DiceValue value, {TextStyle? style})
      : super(
          children: [
            ValueSpan(value.diceCountValue, style: style),
            TextSpan(text: value.sideText, style: style),
            for (final entry in _sort(value.diceBonuses))
              DiceBonusSpan(
                bonus: entry.bonus,
                dice: entry.value,
                noColor: ignoreBonusColor(entry.bonus),
                style: style,
              ),
            BonusValueSpan(value.intBonusValue, style: style),
          ],
        );

  static List<BonusEntry<Dice>> _sort(DiceBonuses bonuses) {
    return bonuses.toList()..sort((a, b) => compareBonus(a.bonus, b.bonus));
  }
}

class DiceValueWithRangeSpan extends TextSpan {
  DiceValueWithRangeSpan(DiceValue value, {TextStyle? style})
      : super(
          children: [
            TextSpan(text: "(", style: style),
            DiceValueSpan(value, style: style),
            TextSpan(text: ") ", style: style),
            RangeSpan(value.range, max: value.max, style: style),
          ],
        );
}

class DiceRollValueSpan extends ValueSpan<Int> {
  DiceRollValueSpan(DiceRollValue value, {TextStyle? style})
      : super(
          value.intValue,
          tooltipBaseText: "Rolled (${value.base.dice})",
          style: style,
        );
}

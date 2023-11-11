import "package:dungeons/game/bonuses.dart";
import "package:dungeons/game/value.dart";
import "package:dungeons/utility/bonus_text.dart";
import "package:dungeons/utility/fixed_string.dart";
import "package:dungeons/utility/multiplier.dart";
import "package:dungeons/utility/percent.dart";
import "package:dungeons/widget/colors.dart";
import "package:dungeons/widget/compare_bonus.dart";
import "package:dungeons/widget/tooltip_region.dart";
import "package:dungeons/widget/value_table.dart";
import "package:flutter/widgets.dart";

class PercentBonusText extends Text {
  PercentBonusText(Percent percent, {super.key, bool noColor = false})
      : super(
          "${bonusText(percent.value)}%",
          style: noColor ? null : TextStyle(color: percentColor(percent)),
        );
}

class PercentValueText extends Text {
  PercentValueText(PercentValue value, {super.key, TextStyle? style})
      : super(
          "$value",
          style: TextStyle(color: percentValueColor(value)).merge(style),
        );
}

class PercentValueTable extends StatelessWidget {
  final PercentValue value;

  const PercentValueTable(this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return ValueTable([
      ValueRow(const Text("Base"), Text("${value.base}")),
      for (final entry in _bonuses)
        if (!entry.value.zero)
          ValueRow(
            Text("${entry.bonus}"),
            PercentBonusText(
              entry.value,
              noColor: ignoreBonusColor(entry.bonus),
            ),
          ),
      for (final entry in _multipliers)
        ValueRow(
          Text("${entry.bonus} (${entry.value})"),
          _DoubleBonusText(
            value.unscaled.value * entry.value.value,
            noColor: ignoreBonusColor(entry.bonus),
          ),
        ),
    ]);
  }

  Iterable<BonusEntry<Percent>> get _bonuses {
    return [
      for (final entry in value.bonuses)
        if (!entry.value.zero) entry,
    ]..sort((a, b) => compareBonus(a.bonus, b.bonus));
  }

  Iterable<BonusEntry<Multiplier>> get _multipliers {
    return [
      for (final entry in value.multipliers)
        if (!entry.value.zero) entry,
    ]..sort((a, b) => compareBonus(a.bonus, b.bonus));
  }
}

class PercentValueWidget extends StatelessWidget {
  final PercentValue value;
  final TextStyle? style;

  const PercentValueWidget(this.value, {super.key, this.style});

  Widget get text => PercentValueText(value, style: style);

  @override
  Widget build(BuildContext context) {
    if (value.hasNoBonuses) {
      return text;
    }
    return TooltipRegion(
      tooltip: PercentValueTable(value),
      child: text,
    );
  }
}

class PercentValueSpan extends WidgetSpan {
  PercentValueSpan(PercentValue value, {TextStyle? style})
      : super(child: PercentValueWidget(value, style: style));
}

class PercentValueRollSpan extends TextSpan {
  PercentValueRollSpan(PercentValueRoll value, {bool critical = false})
      : super(
          children: [
            const TextSpan(text: "("),
            PercentValueSpan(value.input),
            TextSpan(text: ") ${value.result.text(critical)}"),
          ],
        );
}

class _DoubleBonusText extends Text {
  _DoubleBonusText(double value, {bool noColor = false})
      : super(
          "${toFixedBonusString(value)}%",
          style: noColor ? null : TextStyle(color: doubleColor(value)),
        );
}

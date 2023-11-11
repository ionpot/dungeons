import "package:dungeons/game/bonuses.dart";
import "package:dungeons/game/value.dart";
import "package:dungeons/utility/bonus_text.dart";
import "package:dungeons/widget/colors.dart";
import "package:dungeons/widget/compare_bonus.dart";
import "package:dungeons/widget/empty.dart";
import "package:dungeons/widget/tooltip_region.dart";
import "package:dungeons/widget/value_table.dart";
import "package:flutter/widgets.dart";

class IntBonusPlainText extends Text {
  IntBonusPlainText(int value, {super.key, TextStyle? style})
      : super(bonusText(value), style: style);
}

class IntBonusText extends IntBonusPlainText {
  IntBonusText(super.value, {super.key, TextStyle? style})
      : super(style: TextStyle(color: intColor(value)).merge(style));
}

class IntBonusTable extends StatelessWidget {
  final IntValue value;

  const IntBonusTable(this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return ValueTable([
      if (value.base != 0)
        ValueRow(const Text("Base"), IntBonusPlainText(value.base)),
      ...bonusRows(value.bonuses),
    ]);
  }

  static List<ValueRow> bonusRows(IntBonuses bonuses) {
    final ls = bonuses.toList()..sort((a, b) => compareBonus(a.bonus, b.bonus));
    return [
      for (final entry in ls)
        if (entry.value != 0)
          ValueRow(
            Text("${entry.bonus}"),
            ignoreBonusColor(entry.bonus)
                ? IntBonusPlainText(entry.value)
                : IntBonusText(entry.value),
          ),
    ];
  }
}

class IntBonusWidget extends StatelessWidget {
  final IntValue value;
  final TextStyle? style;

  const IntBonusWidget(this.value, {super.key, this.style});

  @override
  Widget build(BuildContext context) {
    if (value.bonuses.isEmpty) {
      return value.base == 0
          ? const Empty()
          : IntBonusPlainText(value.base, style: style);
    }
    return TooltipRegion(
      tooltip: IntBonusTable(value),
      child: IntBonusPlainText(
        value.total,
        style: TextStyle(color: intValueColor(value)).merge(style),
      ),
    );
  }
}

class IntBonusSpan extends WidgetSpan {
  IntBonusSpan(IntValue value, {TextStyle? style})
      : super(child: IntBonusWidget(value, style: style));
}

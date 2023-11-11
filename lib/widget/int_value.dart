import "package:dungeons/game/value.dart";
import "package:dungeons/widget/colors.dart";
import "package:dungeons/widget/int_bonus.dart";
import "package:dungeons/widget/tooltip_region.dart";
import "package:dungeons/widget/value_table.dart";
import "package:flutter/widgets.dart";

class IntValueText extends Text {
  IntValueText(IntValue value, {super.key, TextStyle? style})
      : super(
          "$value",
          style: TextStyle(color: intValueColor(value)).merge(style),
        );
}

class IntValueTable extends StatelessWidget {
  final IntValue value;
  final String? baseText;

  const IntValueTable(this.value, {super.key, this.baseText});

  @override
  Widget build(BuildContext context) {
    return ValueTable(rows(value, base: baseText));
  }

  static List<ValueRow> rows(IntValue value, {String? base}) {
    return [
      ValueRow(Text(base ?? "Base"), Text("${value.base}")),
      ...IntBonusTable.bonusRows(value.bonuses),
    ];
  }
}

class IntValueWidget extends StatelessWidget {
  final IntValue value;
  final String? baseText;
  final TextStyle? style;

  const IntValueWidget(this.value, {super.key, this.baseText, this.style});

  Widget get text => IntValueText(value, style: style);

  @override
  Widget build(BuildContext context) {
    if (value.bonuses.isEmpty) {
      return text;
    }
    return TooltipRegion(
      tooltip: IntValueTable(value, baseText: baseText),
      child: text,
    );
  }
}

class IntValueSpan extends WidgetSpan {
  IntValueSpan(IntValue value, {TextStyle? style})
      : super(child: IntValueWidget(value, style: style));
}

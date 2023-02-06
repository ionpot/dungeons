import 'package:dungeons/game/value.dart';
import 'package:dungeons/utility/bonus_text.dart';
import 'package:dungeons/widget/bold_text.dart';
import 'package:dungeons/widget/colors.dart';
import 'package:dungeons/widget/tooltip_region.dart';
import 'package:dungeons/widget/value_table.dart';
import 'package:flutter/widgets.dart';

class IntBonusText extends Text {
  IntBonusText(int value, {super.key})
      : super(
          bonusText(value),
          style: TextStyle(color: intColor(value)),
        );
}

class IntValueText extends Text {
  IntValueText(IntValue value, {super.key, TextStyle? style})
      : super(
          '$value',
          style: TextStyle(color: intValueColor(value)).merge(style),
        );
}

class IntValueTable extends StatelessWidget {
  final IntValue value;

  const IntValueTable(this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return ValueTable([
      ValueRow(const Text('Base'), Text('${value.base}')),
      for (final entry in value.bonuses.contents.entries)
        ValueRow(Text('${entry.key}'), IntBonusText(entry.value)),
    ]);
  }
}

class IntValueWidget extends StatelessWidget {
  final IntValue value;
  final TextStyle? style;

  const IntValueWidget(this.value, {super.key, this.style});

  Widget get text => IntValueText(value, style: style);

  @override
  Widget build(BuildContext context) {
    if (value.bonuses.isEmpty) {
      return text;
    }
    return TooltipRegion(
      content: IntValueTable(value),
      child: text,
    );
  }
}

class IntValueSpan extends WidgetSpan {
  IntValueSpan(IntValue value, {TextStyle? style})
      : super(child: IntValueWidget(value, style: style));

  factory IntValueSpan.bold(IntValue value) {
    return IntValueSpan(value, style: BoldText.style);
  }
}

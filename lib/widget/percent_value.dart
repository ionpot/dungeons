import 'package:dungeons/game/value.dart';
import 'package:dungeons/utility/bonus_text.dart';
import 'package:dungeons/utility/fixed_string.dart';
import 'package:dungeons/utility/percent.dart';
import 'package:dungeons/widget/bold_text.dart';
import 'package:dungeons/widget/colors.dart';
import 'package:dungeons/widget/tooltip_region.dart';
import 'package:flutter/widgets.dart';

class PercentBonusText extends Text {
  PercentBonusText(Percent percent, {super.key})
      : super(
          '${bonusText(percent.value)}%',
          style: TextStyle(color: percentColor(percent)),
        );
}

class PercentValueText extends Text {
  PercentValueText(PercentValue value, {super.key, TextStyle? style})
      : super(
          '$value',
          style: TextStyle(color: percentValueColor(value)).merge(style),
        );
}

class PercentValueTable extends StatelessWidget {
  final PercentValue value;

  const PercentValueTable(this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Table(
      defaultColumnWidth: const IntrinsicColumnWidth(),
      children: [
        _row(const Text('Base'), Text('${value.base}')),
        for (final entry in value.bonuses.contents.entries)
          _row(Text('${entry.key}'), PercentBonusText(entry.value)),
        for (final entry in value.multipliers.contents.entries)
          _row(
            Text('${entry.key} (${entry.value})'),
            _DoubleBonusText(value.unscaled.value * entry.value.value),
          ),
      ],
    );
  }

  static TableRow _row(Widget label, Widget value) {
    return TableRow(children: [_cell(label), _cell(value)]);
  }

  static TableCell _cell(Widget child) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: child,
      ),
    );
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
      content: PercentValueTable(value),
      child: text,
    );
  }
}

class PercentValueSpan extends WidgetSpan {
  PercentValueSpan(PercentValue value, {TextStyle? style})
      : super(child: PercentValueWidget(value, style: style));

  factory PercentValueSpan.bold(PercentValue value) {
    return PercentValueSpan(value, style: BoldText.style);
  }
}

class PercentValueRollSpan extends TextSpan {
  PercentValueRollSpan(PercentValueRoll value)
      : super(
          children: [
            const TextSpan(text: '('),
            PercentValueSpan(value.input),
            TextSpan(text: ') ${value.result}'),
          ],
        );
}

class _DoubleBonusText extends Text {
  _DoubleBonusText(double value)
      : super(
          '${toFixedBonusString(value)}%',
          style: TextStyle(color: doubleColor(value)),
        );
}

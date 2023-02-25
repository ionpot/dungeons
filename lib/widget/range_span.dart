import 'package:dungeons/game/bonus.dart';
import 'package:dungeons/utility/range.dart';
import 'package:dungeons/widget/colors.dart';
import 'package:dungeons/widget/tooltip_region.dart';
import 'package:dungeons/widget/value_table.dart';
import 'package:flutter/widgets.dart';

class RangeSpan extends WidgetSpan {
  RangeSpan(Range range, {Bonus? max, TextStyle? style})
      : super(child: RangeWidget(range, max: max, style: style));
}

class RangeWidget extends StatelessWidget {
  final Range range;
  final Bonus? max;
  final TextStyle? style;

  const RangeWidget(this.range, {super.key, this.max, this.style});

  Text get text {
    return Text(
      '${max != null ? range.max : range}',
      style: baseStyle.merge(style),
    );
  }

  TextStyle get baseStyle => TextStyle(color: max != null ? green : null);

  @override
  Widget build(BuildContext context) {
    if (max == null) {
      return text;
    }
    return TooltipRegion(
      tooltip: ValueTable([
        ValueRow(const Text('Range'), Text('$range')),
        ValueRow(Text('$max'), Text('${range.max}', style: baseStyle)),
      ]),
      child: text,
    );
  }
}

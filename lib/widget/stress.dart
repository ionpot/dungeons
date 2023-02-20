import 'package:dungeons/game/bonuses.dart';
import 'package:dungeons/game/entity.dart';
import 'package:dungeons/widget/colors.dart';
import 'package:dungeons/widget/int_value.dart';
import 'package:dungeons/widget/tooltip_region.dart';
import 'package:dungeons/widget/value_table.dart';
import 'package:flutter/widgets.dart';

class StressSpan extends TextSpan {
  StressSpan(Entity entity)
      : super(
          children: [
            TextSpan(text: '${entity.stress}/'),
            StressCapSpan(entity),
          ],
        );
}

class StressCapSpan extends WidgetSpan {
  StressCapSpan(Entity entity, {TextStyle? style})
      : super(child: StressCapWidget(entity, style: style));
}

class StressCapWidget extends StatelessWidget {
  final Entity entity;
  final TextStyle? style;

  const StressCapWidget(this.entity, {super.key, this.style});

  @override
  Widget build(BuildContext context) {
    if (entity.reservedStress.isEmpty) {
      return IntValueWidget(entity.stressCapValue, style: style);
    }
    return TooltipRegion(
      content: ValueTable(
        IntValueTable.rows(entity.stressCapValue)
          ..addAll(reservedRows(entity.reservedStress)),
      ),
      child: reservedText(entity.stressCap, style: style),
    );
  }

  static List<ValueRow> reservedRows(IntBonuses bonuses) {
    return [
      for (final entry in bonuses)
        ValueRow(
          Text('${entry.bonus}'),
          reservedText(-entry.value),
        ),
    ];
  }

  static Widget reservedText(int value, {TextStyle? style}) {
    return Text(
      '$value',
      style: const TextStyle(color: yellow).merge(style),
    );
  }
}

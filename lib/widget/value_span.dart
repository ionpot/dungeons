import "package:dungeons/game/value.dart";
import "package:dungeons/utility/monoids.dart";
import "package:dungeons/widget/colors.dart";
import "package:dungeons/widget/empty.dart";
import "package:dungeons/widget/text.dart";
import "package:dungeons/widget/tooltip_region.dart";
import "package:dungeons/widget/value_tooltip.dart";
import "package:flutter/widgets.dart";

class ValueSpan<T extends Monoid> extends WidgetSpan {
  ValueSpan(Value<T> value, {String? tooltipBaseText, TextStyle? style})
      : super(
          child: TooltipRegion(
            tooltip: ValueTooltip(
              value,
              baseLabel: tooltipBaseText ?? "Base",
            ),
            disabled: ValueTooltip.isEmpty(value),
            child: ColoredText(value, valueColor(value), style: style),
          ),
        );
}

class BonusValueSpan<T extends Monoid> extends WidgetSpan {
  BonusValueSpan(Value<T> value, {String? tooltipBaseText, TextStyle? style})
      : super(
          child: ValueTooltip.isEmpty(value)
              ? const Empty()
              : TooltipRegion(
                  tooltip: ValueTooltip(value),
                  child: ColoredText(
                    value.total.signed,
                    valueColor(value),
                    style: style,
                  ),
                ),
        );
}

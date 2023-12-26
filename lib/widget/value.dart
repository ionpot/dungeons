import "package:dungeons/game/value.dart";
import "package:dungeons/utility/monoids.dart";
import "package:dungeons/widget/colors.dart";
import "package:dungeons/widget/tooltip_region.dart";
import "package:dungeons/widget/value_tooltip.dart";
import "package:flutter/widgets.dart";

class ValueText<T extends Monoid> extends StatelessWidget {
  final Value<T> value;
  final bool asBonus;
  final String? tooltipBaseText;
  final TextStyle? style;

  const ValueText(
    this.value, {
    super.key,
    this.asBonus = false,
    this.tooltipBaseText,
    this.style,
  });

  String _value(T v) => asBonus ? v.signed : "$v";

  Widget get text {
    return Text(
      _value(value.total),
      style: TextStyle(color: valueColor(value)).merge(style),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (value.hasNoBonuses) {
      return text;
    }
    return TooltipRegion(
      tooltip: ValueTooltip(
        value,
        baseLabel: tooltipBaseText ?? "Base",
        baseText: Text(_value(value.base)),
      ),
      child: text,
    );
  }
}

class ValueSpan<T extends Monoid> extends WidgetSpan {
  ValueSpan(Value<T> value, {String? tooltipBaseText, TextStyle? style})
      : super(
          child: ValueText(
            value,
            tooltipBaseText: tooltipBaseText,
            style: style,
          ),
        );
}

class BonusValueSpan<T extends Monoid> extends WidgetSpan {
  BonusValueSpan(Value<T> value, {String? tooltipBaseText, TextStyle? style})
      : super(
          child: ValueText(
            value,
            asBonus: true,
            tooltipBaseText: tooltipBaseText,
            style: style,
          ),
        );
}

import "package:dungeons/game/entity/bonus.dart";
import "package:dungeons/game/entity/bonus_entry.dart";
import "package:dungeons/game/entity/value.dart";
import "package:dungeons/utility/monoids.dart";
import "package:dungeons/widget/colors.dart";
import "package:dungeons/widget/empty.dart";
import "package:dungeons/widget/text.dart";
import "package:dungeons/widget/tooltip_region.dart";
import "package:dungeons/widget/value_tooltip.dart";
import "package:flutter/widgets.dart";

class ValueSpan<T extends Monoid> extends WidgetSpan {
  ValueSpan(
    Value<T> value, {
    String? tooltipBaseText,
    IgnoreBonusColor? ignoreBonusColor,
    TextStyle? style,
  }) : super(
          child: TooltipRegion(
            tooltip: ValueTooltip(
              value,
              baseLabel: tooltipBaseText ?? "Base",
              ignoreColor: ignoreBonusColor,
            ),
            disabled: ValueTooltip.isEmpty(value),
            child: ColoredText(
              value,
              _valueColor(value, ignoreBonusColor),
              style: style,
            ),
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
                    _valueColor(value),
                    style: style,
                  ),
                ),
        );
}

class ArmorValueSpan extends ValueSpan<Int> {
  ArmorValueSpan(super.value, {super.tooltipBaseText, super.style})
      : super(
          ignoreBonusColor: (bonus) {
            if (bonus is GearBonus) {
              return bonus.gear.body != null;
            }
            return ignoreBonusColor(bonus);
          },
        );
}

Color? _valueColor<T extends Monoid>(
  Value<T> value, [
  IgnoreBonusColor? ignore,
]) {
  if (value.reserved.total.hasValue) {
    return reservedColor;
  }
  final list = value.bonusList..removeWhereBonus(ignore ?? ignoreBonusColor);
  return monoidColor(list.total);
}

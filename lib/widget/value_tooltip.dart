import "package:dungeons/game/bonus.dart";
import "package:dungeons/game/bonus_entry.dart";
import "package:dungeons/game/value.dart";
import "package:dungeons/utility/monoids.dart";
import "package:dungeons/widget/colors.dart";
import "package:dungeons/widget/compare_bonus.dart";
import "package:dungeons/widget/text.dart";
import "package:dungeons/widget/value_table.dart";
import "package:flutter/widgets.dart";

class ValueTooltip<T extends Monoid> extends StatelessWidget {
  final Value<T> value;
  final String? baseLabel;

  const ValueTooltip(
    this.value, {
    super.key,
    this.baseLabel,
  });

  static bool isEmpty<T extends Monoid>(Value<T> value) {
    return value.bonusList.clean.isEmpty && value.reserved.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final base = value.base;
    return ValueTable([
      if (base.hasValue) ValueRow(Text(baseLabel ?? "Base"), BoldText("$base")),
      ..._bonusRows,
      ..._reservedRows,
    ]);
  }

  List<ValueRow> get _bonusRows {
    final bonuses = value.bonusList.clean
      ..sort((a, b) => compareBonus(a.bonus, b.bonus));

    Color? color(Bonus bonus, T value) =>
        ignoreBonusColor(bonus) ? null : monoidColor(value);

    return [
      for (final BonusEntry(:bonus, :value) in bonuses)
        ValueRow(
          Text("$bonus"),
          BoldText(value.signed, color: color(bonus, value)),
        ),
    ];
  }

  List<ValueRow> get _reservedRows {
    final bonuses = value.reserved.clean.group.toList()
      ..sort((a, b) => compareBonus(a.bonus, b.bonus));

    String label(Bonus bonus, List<T> value) {
      final count = value.length;
      return count > 1 ? "$bonus (x$count)" : "$bonus";
    }

    return [
      for (final BonusEntry(:bonus, :value) in bonuses)
        ValueRow(
          Text(label(bonus, value)),
          BoldText(value.total.negate, color: reservedColor),
        ),
    ];
  }
}

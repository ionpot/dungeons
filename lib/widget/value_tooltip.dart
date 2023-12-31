import "package:dungeons/game/bonus.dart";
import "package:dungeons/game/bonus_entry.dart";
import "package:dungeons/game/value.dart";
import "package:dungeons/utility/monoids.dart";
import "package:dungeons/widget/colors.dart";
import "package:dungeons/widget/compare_bonus.dart";
import "package:dungeons/widget/text.dart";
import "package:dungeons/widget/value_table.dart";
import "package:flutter/widgets.dart";

typedef IgnoreBonusColor = bool Function(Bonus);

class ValueTooltip<T extends Monoid> extends StatelessWidget {
  final Value<T> input;
  final String? baseLabel;
  final IgnoreBonusColor? ignoreColor;

  const ValueTooltip(
    this.input, {
    super.key,
    this.baseLabel,
    this.ignoreColor,
  });

  static bool isEmpty<T extends Monoid>(Value<T> value) {
    return value.bonusList.clean.isEmpty && value.reserved.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final base = input.base;
    return ValueTable([
      if (base.hasValue) ValueRow(Text(baseLabel ?? "Base"), BoldText(base)),
      ..._bonusRows,
      ..._reservedRows,
    ]);
  }

  _Row _row(String label, Bonus bonus, T value) {
    return _Row(label, bonus, value, ignoreColor ?? ignoreBonusColor);
  }

  Iterable<ValueRow> get _bonusRows {
    final rows = <_Row>[];
    for (final BonusEntry(:bonus, :value) in input.bonuses.grouped) {
      rows.add(_row(_label(bonus, value), bonus, value.total));
    }
    for (final BonusEntry(:bonus, :value) in input.multipliers.grouped) {
      final total = value.total;
      rows.add(_row("$bonus ($total)", bonus, input.multiply(total)));
    }
    rows.sort();
    return rows.map((row) => row.bonusRow);
  }

  Iterable<ValueRow> get _reservedRows {
    final list = input.reserved.clean.group.toList();
    final rows = <_Row>[];
    for (final BonusEntry(:bonus, :value) in list) {
      rows.add(_row(_label(bonus, value), bonus, value.total));
    }
    return rows.map((row) => row.reservedRow);
  }

  static String _label<T extends Monoid>(Bonus bonus, List<T> values) {
    final count = values.length;
    return count > 1 ? "$bonus ($count)" : "$bonus";
  }
}

class _Row<T extends Monoid> implements Comparable<_Row<T>> {
  final String label;
  final Bonus bonus;
  final T value;
  final IgnoreBonusColor ignoreColor;

  const _Row(this.label, this.bonus, this.value, this.ignoreColor);

  Color? get color => ignoreColor(bonus) ? null : monoidColor(value);

  ValueRow get bonusRow {
    return ValueRow(
      Text(label),
      BoldText(value.signed, color: color),
    );
  }

  ValueRow get reservedRow {
    return ValueRow(
      Text(label),
      BoldText(value.negate, color: reservedColor),
    );
  }

  @override
  int compareTo(_Row<T> other) => compareBonus(bonus, other.bonus);
}

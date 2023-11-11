import "package:flutter/widgets.dart";

class ValueRow {
  final Widget label;
  final Widget value;

  const ValueRow(this.label, this.value);
}

class ValueTable extends StatelessWidget {
  final List<ValueRow> rows;

  const ValueTable(this.rows, {super.key});

  @override
  Widget build(BuildContext context) {
    return Table(
      defaultColumnWidth: const IntrinsicColumnWidth(),
      children: [
        for (final row in rows)
          TableRow(children: [_cell(row.label), _cell(row.value)]),
      ],
    );
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

import "package:flutter/widgets.dart";

typedef LabelValueMap = Map<String, Widget>;

class LabelValueTable extends StatelessWidget {
  final LabelValueMap content;
  final double labelWidth;
  final double valueWidth;

  const LabelValueTable({
    super.key,
    required this.content,
    required this.labelWidth,
    required this.valueWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: <int, TableColumnWidth>{
        0: FixedColumnWidth(labelWidth),
        1: FixedColumnWidth(valueWidth),
      },
      children: [
        for (final e in content.entries) _buildRow(e.key, e.value),
      ],
    );
  }

  TableRow _buildRow(String label, Widget value) {
    return TableRow(
      children: [
        _buildCell(Text(label)),
        _buildCell(value),
      ],
    );
  }

  TableCell _buildCell(Widget child) {
    return TableCell(
      child: Container(
        padding: const EdgeInsets.only(bottom: 8),
        child: child,
      ),
    );
  }
}

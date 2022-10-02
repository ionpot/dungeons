import 'package:flutter/widgets.dart';

typedef LabelValueMap = Map<String, String>;

class LabelValueTable extends StatelessWidget {
  final LabelValueMap content;
  final double labelWidth;

  const LabelValueTable({
    super.key,
    required this.content,
    required this.labelWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: <int, TableColumnWidth>{
        0: FixedColumnWidth(labelWidth),
        1: const IntrinsicColumnWidth(),
      },
      children: [
        for (final e in content.entries) _buildRow(e.key, e.value),
      ],
    );
  }

  TableRow _buildRow(String label, String value) {
    return TableRow(
      children: [
        _buildCell(Text(label)),
        _buildCell(Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        )),
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

import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/entity_attr.dart';
import 'package:flutter/widgets.dart';

class EntityInfo extends StatelessWidget {
  final Entity entity;

  const EntityInfo(this.entity, {super.key});

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const <int, TableColumnWidth>{
        0: FixedColumnWidth(64),
        1: IntrinsicColumnWidth(),
      },
      children: [
        for (final id in EntityAttributeId.values)
          _buildRow(id.text, entity.attributes.ofId(id).toString()),
        _buildRow('Total Hp', entity.totalHp().toString()),
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

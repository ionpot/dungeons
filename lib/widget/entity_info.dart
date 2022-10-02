import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/entity_attr.dart';
import 'package:flutter/widgets.dart';

class EntityInfo extends StatelessWidget {
  final EntityAttributes attributes;

  EntityInfo(Entity entity, {super.key}) : attributes = entity.attributes;

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const <int, TableColumnWidth>{
        0: FixedColumnWidth(64),
        1: IntrinsicColumnWidth(),
      },
      children: [
        for (final id in EntityAttributeId.values)
          TableRow(children: [
            TableCell(
              child: Container(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(id.text),
              ),
            ),
            TableCell(child: Text(attributes.ofId(id).toString())),
          ])
      ],
    );
  }
}

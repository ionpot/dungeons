import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/entity_attr.dart';
import 'package:dungeons/widget/label_value.dart';
import 'package:flutter/widgets.dart';

class EntityInfo extends StatelessWidget {
  final Entity entity;

  const EntityInfo(this.entity, {super.key});

  @override
  Widget build(BuildContext context) {
    LabelValueMap content = {};
    for (final id in EntityAttributeId.values) {
      content[id.text] = entity.attributes.ofId(id).toString();
    }
    content['Total Hp'] = entity.totalHp().toString();
    content['Armor'] = entity.totalArmor().toString();
    return LabelValueTable(
      labelWidth: 64,
      content: content,
    );
  }
}

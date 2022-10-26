import 'package:dungeons/game/entity_attr.dart';
import 'package:dungeons/utility/value_callback.dart';
import 'package:dungeons/widget/button.dart';
import 'package:flutter/widgets.dart';

class AttributeSelect extends StatelessWidget {
  final ValueCallback<EntityAttributeId> onChosen;

  const AttributeSelect({super.key, required this.onChosen});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.vertical,
      spacing: 12,
      children: [
        for (final id in EntityAttributeId.values)
          Button(id.text, onClick: () => onChosen(id)),
      ],
    );
  }
}

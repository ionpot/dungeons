import 'package:dungeons/game/entity_attr.dart';
import 'package:dungeons/utility/value_callback.dart';
import 'package:dungeons/widget/attribute_select.dart';
import 'package:dungeons/widget/spaced_row.dart';
import 'package:dungeons/widget/titled_text_lines.dart';
import 'package:flutter/widgets.dart';

class CombatLevel extends StatelessWidget {
  final int points;
  final ValueCallback<EntityAttributeId> onPoint;

  const CombatLevel(this.points, {super.key, required this.onPoint});

  @override
  Widget build(BuildContext context) {
    return buildSpacedRow(
      spacing: 60,
      children: [
        AttributeSelect(onChosen: onPoint),
        TitledTextLines.plain(
          title: 'Choose attributes',
          lines: ['Points remaining: $points'],
        ),
      ],
    );
  }
}

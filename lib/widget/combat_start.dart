import 'package:dungeons/game/combat.dart';
import 'package:dungeons/widget/button.dart';
import 'package:dungeons/widget/spaced_row.dart';
import 'package:flutter/widgets.dart';

class CombatStart extends StatelessWidget {
  final Combat combat;
  final VoidCallback onDone;

  const CombatStart(this.combat, {super.key, required this.onDone});

  @override
  Widget build(BuildContext context) {
    return buildSpacedRow(
      spacing: 60,
      children: [
        Button(text: 'Next', onClick: onDone),
        Text('${combat.first.name} goes first.'),
      ],
    );
  }
}

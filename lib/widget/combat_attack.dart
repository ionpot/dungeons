import 'package:dungeons/game/attack.dart';
import 'package:dungeons/game/combat.dart';
import 'package:dungeons/widget/attack_text.dart';
import 'package:dungeons/widget/button.dart';
import 'package:dungeons/widget/spaced.dart';
import 'package:flutter/widgets.dart';

class CombatAttack extends StatelessWidget {
  final Attack attack;
  final Combat combat;
  final VoidCallback onDone;

  const CombatAttack(
    this.combat,
    this.attack, {
    super.key,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return buildSpacedRow(
      children: [
        Button(text: 'Next', onClick: onDone),
        AttackText(attack, combat),
      ],
    );
  }
}

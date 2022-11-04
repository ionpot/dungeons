import 'package:dungeons/game/attack.dart';
import 'package:dungeons/game/combat.dart';
import 'package:dungeons/widget/attack_text.dart';
import 'package:dungeons/widget/button.dart';
import 'package:dungeons/widget/spaced.dart';
import 'package:flutter/widgets.dart';

class CombatAttack extends StatelessWidget {
  final WeaponAttack attack;
  final WeaponAttackResult result;
  final Combat combat;
  final VoidCallback onDone;

  const CombatAttack(
    this.attack,
    this.result,
    this.combat, {
    super.key,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return buildSpacedRow(
      children: [
        Button('Next', onClick: onDone),
        AttackText(attack, result, combat),
      ],
    );
  }
}

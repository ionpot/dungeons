import 'package:dungeons/game/attack.dart';
import 'package:dungeons/game/entity.dart';
import 'package:dungeons/widget/attack_text.dart';
import 'package:dungeons/widget/titled_text_lines.dart';
import 'package:flutter/widgets.dart';

class CombatText extends StatelessWidget {
  final Attack? attack;
  final int round;
  final int xpGain;
  final Entity player;
  final Entity first;

  const CombatText({
    super.key,
    this.attack,
    required this.round,
    required this.xpGain,
    required this.player,
    required this.first,
  });

  @override
  Widget build(BuildContext context) {
    if (player.extraPoints > 0) {
      return TitledTextLines.plain(
        title: 'Choose attributes',
        lines: ['Points remaining: ${player.extraPoints}'],
      );
    }
    if (attack != null) {
      return AttackText(attack!, round: round, xpGain: xpGain);
    }
    return Text('${first.name} goes first.');
  }
}

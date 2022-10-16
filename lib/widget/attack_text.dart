import 'package:dungeons/game/attack.dart';
import 'package:dungeons/widget/bold_text.dart';
import 'package:dungeons/widget/text_lines.dart';
import 'package:flutter/widgets.dart';

class AttackText extends StatelessWidget {
  final Attack attack;
  final int round;
  final int xpGain;

  const AttackText(
    this.attack, {
    super.key,
    required this.round,
    required this.xpGain,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BoldText('Round $round'),
        const SizedBox(height: 12),
        TextLines(_lines),
      ],
    );
  }

  List<String> get _lines {
    final from = attack.from;
    final target = attack.target;
    final lines = <String>[
      '${from.name} attacks ${target.name} '
          'with ${from.weapon?.text}.',
      'Attack roll ${attack.roll}',
    ];
    if (attack.roll.fail) {
      lines.add('${target.name} deflects the attack.');
      return lines;
    }
    if (attack.dodge != null) {
      lines.add('Dodge roll ${attack.dodge}');
      if (attack.dodge!.success) {
        lines.add('${target.name} dodges the attack.');
        return lines;
      }
    }
    if (attack.damage != null) {
      lines.add('${target.name} takes ${attack.damage} damage'
          '${target.dead ? ', and dies' : ''}.');
      if (target.dead && from.player && xpGain > 0) {
        lines.add('${from.name} gains $xpGain XP'
            '${from.canLevelUpWith(xpGain) ? ', and levels up' : ''}.');
      }
    }
    return lines;
  }
}

import 'package:dungeons/game/attack.dart';
import 'package:dungeons/game/combat.dart';
import 'package:dungeons/widget/titled_text_lines.dart';
import 'package:flutter/widgets.dart';

class AttackText extends StatelessWidget {
  final Attack attack;
  final int round;
  final int xpGain;

  AttackText(
    this.attack,
    Combat combat, {
    super.key,
  })  : round = combat.round,
        xpGain = combat.xpGain;

  @override
  Widget build(BuildContext context) {
    return TitledTextLines.plain(title: 'Round $round', lines: _lines);
  }

  List<String> get _lines {
    final from = attack.from;
    final target = attack.target;
    final value = attack.value;
    final result = attack.result;
    final lines = <String>[
      '${from.name} attacks ${target.name} '
          'with ${from.weapon?.text}.',
      'Attack roll (${value.hitChance}) ${result.hit}',
    ];
    if (result.hit.fail) {
      lines.add('${target.name} deflects the attack.');
      return lines;
    }
    if (result.dodge != null) {
      lines.add('Dodge roll (${value.dodgeChance}) ${result.dodge}');
      if (result.dodge!.success) {
        lines.add('${target.name} dodges the attack.');
        return lines;
      }
    }
    if (result.damage != null) {
      lines.add('${target.name} takes ${result.damage} damage'
          '${target.dead ? ', and dies' : ''}.');
      if (target.dead && from.player && xpGain > 0) {
        lines.add('${from.name} gains $xpGain XP'
            '${from.canLevelUpWith(xpGain) ? ', and levels up' : ''}.');
      }
    }
    return lines;
  }
}

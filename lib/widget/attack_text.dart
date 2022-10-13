import 'package:dungeons/game/attack.dart';
import 'package:dungeons/widget/text_lines.dart';
import 'package:flutter/widgets.dart';

class AttackText extends StatelessWidget {
  final Attack attack;

  const AttackText(this.attack, {super.key});

  @override
  Widget build(BuildContext context) => TextLines(_lines);

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
          '${target.isDead() ? ', and dies' : ''}.');
    }
    return lines;
  }
}

import 'package:dungeons/game/attack.dart';
import 'package:dungeons/game/combat.dart';
import 'package:dungeons/game/entity.dart';
import 'package:dungeons/widget/text_lines.dart';
import 'package:dungeons/widget/titled_text_lines.dart';
import 'package:dungeons/widget/value_span.dart';
import 'package:flutter/widgets.dart';

class AttackText extends StatelessWidget {
  final Attack attack;
  final AttackResult result;
  final int round;
  final int xpGain;

  AttackText(
    this.attack,
    this.result,
    Combat combat, {
    super.key,
  })  : round = combat.round,
        xpGain = combat.xpGain;

  @override
  Widget build(BuildContext context) {
    return TitledTextLines(
      title: 'Round $round',
      lines: TextLines(_lines),
    );
  }

  Entity get _from => attack.from;
  Entity get _target => attack.target;

  List<Widget> get _lines {
    final lines = <Widget>[
      Text('${_from.name} attacks ${_target.name} '
          'with ${_from.weapon?.text}.'),
      _attackRoll,
    ];
    if (result.hit.fail) {
      lines.add(Text('${_target.name} deflects the attack.'));
      return lines;
    }
    if (result.dodge != null) {
      lines.add(_dodgeRoll);
      if (result.dodge!.success) {
        lines.add(Text('${_target.name} dodges the attack.'));
        return lines;
      }
    }
    if (result.sneakDamage != null) {
      lines.add(
          Text('Sneak attack (${attack.sneakDamage}) ${result.sneakDamage}'));
    }
    if (result.damage != null) {
      lines.add(_damageRoll);
      if (_target.dead && _from.player && xpGain > 0) {
        lines.add(Text('${_from.name} gains $xpGain XP'
            '${_from.canLevelUpWith(xpGain) ? ', and levels up' : ''}.'));
      }
    }
    return lines;
  }

  Widget get _attackRoll {
    return Text.rich(
      TextSpan(
        children: [
          const TextSpan(text: 'Attack roll ('),
          PercentValueSpan(attack.hitChance),
          TextSpan(text: ') ${result.hit}'),
        ],
      ),
    );
  }

  Widget get _dodgeRoll {
    return Text.rich(
      TextSpan(
        children: [
          const TextSpan(text: 'Dodge roll ('),
          PercentValueSpan(attack.dodgeChance),
          TextSpan(text: ') ${result.dodge}'),
        ],
      ),
    );
  }

  Widget get _damageRoll {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: '${_target.name} takes '),
          IntValueSpan(result.damage!),
          TextSpan(
            text: ' damage${_target.dead ? ', and dies' : ''}.',
          ),
        ],
      ),
    );
  }
}

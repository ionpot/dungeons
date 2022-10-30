import 'package:dungeons/game/attack.dart';
import 'package:dungeons/game/combat.dart';
import 'package:dungeons/game/entity.dart';
import 'package:dungeons/widget/text_lines.dart';
import 'package:dungeons/widget/titled_text_lines.dart';
import 'package:dungeons/widget/value_span.dart';
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
    return TitledTextLines(
      title: 'Round $round',
      lines: TextLines(_lines),
    );
  }

  Entity get _from => attack.from;
  Entity get _target => attack.target;
  AttackValue get _value => attack.value;
  AttackResult get _result => attack.result;

  List<Widget> get _lines {
    final lines = <Widget>[
      Text('${_from.name} attacks ${_target.name} '
          'with ${_from.weapon?.text}.'),
      _attackRoll,
    ];
    if (_result.hit.fail) {
      lines.add(Text('${_target.name} deflects the attack.'));
      return lines;
    }
    if (_result.dodge != null) {
      lines.add(_dodgeRoll);
      if (_result.dodge!.success) {
        lines.add(Text('${_target.name} dodges the attack.'));
        return lines;
      }
    }
    if (_result.damage != null) {
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
          PercentValueSpan(_value.hitChance),
          TextSpan(text: ') ${_result.hit}'),
        ],
      ),
    );
  }

  Widget get _dodgeRoll {
    return Text.rich(
      TextSpan(
        children: [
          const TextSpan(text: 'Dodge roll ('),
          PercentValueSpan(_value.dodgeChance),
          TextSpan(text: ') ${_result.dodge}'),
        ],
      ),
    );
  }

  Widget get _damageRoll {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: '${_target.name} takes '),
          IntValueSpan(_result.damage!),
          TextSpan(
            text: ' damage${_target.dead ? ', and dies' : ''}.',
          ),
        ],
      ),
    );
  }
}

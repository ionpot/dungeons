import 'package:dungeons/game/combat.dart';
import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/spell.dart';
import 'package:dungeons/game/spell_attack.dart';
import 'package:dungeons/game/weapon_attack.dart';
import 'package:dungeons/utility/if.dart';
import 'package:dungeons/utility/value_callback.dart';
import 'package:dungeons/widget/action_select.dart';
import 'package:dungeons/widget/button.dart';
import 'package:dungeons/widget/spaced.dart';
import 'package:dungeons/widget/text_lines.dart';
import 'package:dungeons/widget/titled_text_lines.dart';
import 'package:dungeons/widget/value_span.dart';
import 'package:flutter/widgets.dart';

class CombatDisplay extends StatelessWidget {
  final CombatTurn? turn;
  final int round;
  final Combat combat;
  final ValueCallback<CombatAction> onPlayerAction;
  final VoidCallback onEnemyAction;
  final VoidCallback onWin;
  final VoidCallback onLose;

  const CombatDisplay(
    this.turn,
    this.round,
    this.combat, {
    super.key,
    required this.onPlayerAction,
    required this.onEnemyAction,
    required this.onWin,
    required this.onLose,
  });

  @override
  Widget build(BuildContext context) {
    return buildSpacedRow(
      children: [
        SizedBox(width: 120, child: Wrap(children: [_buildButtons()])),
        ifdef(turn, _buildTurn) ?? Text('${_current.name} goes first.'),
      ],
    );
  }

  Entity get _current => combat.current;

  Widget _buildButtons() {
    if (combat.won) {
      final text = combat.canLevelUp() ? 'Level Up' : 'Next';
      return Button(text, onClick: onWin);
    }
    if (combat.lost) {
      return Button('End', onClick: onLose);
    }
    if (_current.player) {
      return ActionSelect(_current, onChosen: onPlayerAction);
    }
    return Button('Next', onClick: onEnemyAction);
  }

  Widget _buildTurn(CombatTurn turn) {
    return TitledTextLines(
      title: 'Round $round',
      lines: TextLines([
        if (turn.weaponTurn != null) _buildWeapon(turn.weaponTurn!),
        if (turn.spellTurn != null) _buildSpell(turn.spellTurn!),
        if (combat.xpGained) _buildXp(combat.xpGain),
      ]),
    );
  }

  Widget _buildWeapon(WeaponAttackTurn turn) {
    final attack = turn.attack;
    final result = turn.result;
    final from = attack.from;
    final target = attack.target;
    final dodge = ifdef(result.dodge, (d) => d.success);
    return TextLines([
      Text('${from.name} attacks ${target.name} with ${from.weapon?.text}.'),
      _rich(
        'Attack roll (',
        PercentValueSpan(attack.hitChance),
        ') ${result.hit}',
      ),
      if (result.hit.fail) Text('${target.name} deflects the attack.'),
      if (dodge != null)
        _rich(
          'Dodge roll (',
          PercentValueSpan(attack.dodgeChance),
          ') ${result.dodge}',
        ),
      if (dodge == true) Text('${target.name} dodges the attack.'),
      if (result.sneakDamage != null)
        Text('Sneak attack (${attack.sneakDamage}) ${result.sneakDamage}'),
      if (result.damage != null)
        _rich(
          '${target.name} takes ',
          IntValueSpan(result.damage!.value),
          ' damage${_status(target)}.',
        ),
    ]);
  }

  Widget _buildSpell(SpellAttackTurn turn) {
    final attack = turn.attack;
    final result = turn.result;
    final from = attack.from;
    final target = attack.target;
    return TextLines([
      _rich(
        '${from.name} casts ',
        SpellNameSpan(attack.spell),
        ' at ${target.name}',
      ),
      if (!attack.spell.autoHit)
        Text('Resist (${attack.resistChance}) ${result.resist}'),
      if (result.damage != null)
        _rich(
          '${target.name} takes ',
          DamageSpan(result.damage!),
          ' damage${_status(target, turn)}.',
        ),
    ]);
  }

  String _status(Entity target, [SpellAttackTurn? spellTurn]) {
    if (target.dead) {
      return ', and dies';
    }
    if (spellTurn?.result.affected == true) {
      if (spellTurn?.attack.spell == Spell.rayOfFrost) {
        return ', and is slowed';
      }
    }
    return '';
  }

  Widget _buildXp(int xp) {
    final player = combat.player;
    return Text('${player.name} gains $xp XP'
        '${player.canLevelUpWith(xp) ? ', and levels up' : ''}.');
  }

  Widget _rich(String prefix, TextSpan span, String suffix) {
    return Text.rich(
      TextSpan(
        children: [TextSpan(text: prefix), span, TextSpan(text: suffix)],
      ),
    );
  }
}

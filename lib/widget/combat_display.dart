import 'package:dungeons/game/combat.dart';
import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/spell.dart';
import 'package:dungeons/game/spell_cast.dart';
import 'package:dungeons/game/value.dart';
import 'package:dungeons/game/weapon_attack.dart';
import 'package:dungeons/widget/text_lines.dart';
import 'package:dungeons/widget/titled_text_lines.dart';
import 'package:dungeons/widget/value_span.dart';
import 'package:flutter/widgets.dart';

class CombatDisplay extends StatelessWidget {
  final CombatTurn? turn;
  final Combat combat;

  const CombatDisplay(
    this.turn,
    this.combat, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final points = combat.player.extraPoints;
    if (points > 0) {
      return _points(points);
    }
    if (turn != null) {
      return _combatTurn(turn!);
    }
    return Text('${_current.name} goes first.');
  }

  Entity get _current => combat.current;

  Widget _combatTurn(CombatTurn turn) {
    return TitledTextLines(
      title: 'Round ${combat.round}',
      lines: TextLines([
        if (turn.weaponTurn != null) _weaponTurn(turn.weaponTurn!),
        if (turn.spellTurn != null) _spellTurn(turn.spellTurn!),
        if (combat.canGainXp()) _xpText(combat.xpGain),
      ]),
    );
  }

  Widget _weaponTurn(WeaponAttackTurn turn) {
    final attack = turn.attack;
    final result = turn.result;
    final from = attack.from;
    final target = attack.target;
    return TextLines([
      Text('${from.name} attacks ${target.name} with ${from.weapon?.text}.'),
      _richText('Attack roll ', PercentValueRollSpan(result.hit)),
      if (result.hit.fail) Text('${target.name} deflects the attack.'),
      if (result.dodge != null)
        _richText('Dodge roll ', PercentValueRollSpan(result.dodge!)),
      if (result.dodge?.success == true)
        Text('${target.name} dodges the attack.'),
      if (result.sneakDamage != null)
        Text('Sneak attack (${attack.sneakDamage}) ${result.sneakDamage}'),
      if (result.damage != null)
        _damageAndStatus(result.damage!, weaponTurn: turn),
    ]);
  }

  Widget _spellTurn(SpellCastTurn turn) {
    final attack = turn.attack;
    final result = turn.result;
    final from = attack.from;
    final target = attack.target;
    final spell = attack.spell;
    return TextLines([
      _richText(
        '${from.name} casts ',
        SpellNameSpan(spell),
        attack.self ? ' to self.' : ' at ${target.name}.',
      ),
      if (result.resist != null)
        _richText('Resist roll ', PercentValueRollSpan(result.resist!)),
      if (result.damageDice != null)
        Text('Damage roll (${spell.damage}) ${result.damageDice}'),
      if (result.healDice != null)
        Text('Heal roll (${spell.heals}) ${result.healDice}'),
      if (result.healDice != null)
        Text('${target.name} is healed by ${result.healDice!.total}.'),
      if (result.damage != null)
        _damageAndStatus(result.damage!, spellTurn: turn),
    ]);
  }

  Widget _damageAndStatus(
    IntValue damage, {
    WeaponAttackTurn? weaponTurn,
    SpellCastTurn? spellTurn,
  }) {
    final target = weaponTurn?.attack.target ?? spellTurn!.attack.target;
    final source = weaponTurn?.attack.source ?? spellTurn!.attack.source;
    return _richText(
      '${target.name} takes ',
      DamageSpan(damage, source),
      ' damage${_status(target, spellTurn)}.',
    );
  }

  String _status(Entity target, [SpellCastTurn? spellTurn]) {
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

  Widget _xpText(int xp) {
    final player = combat.player;
    return Text('${player.name} gains $xp XP'
        '${player.canLevelUpWith(xp) ? ', and levels up' : ''}.');
  }

  Widget _points(int points) {
    return TitledTextLines.plain(
      title: 'Choose attributes',
      lines: ['Points remaining: $points'],
    );
  }

  Widget _richText(String prefix, TextSpan span, [String suffix = '']) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: prefix),
          span,
          if (suffix != '') TextSpan(text: suffix),
        ],
      ),
    );
  }
}

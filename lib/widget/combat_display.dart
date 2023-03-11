import 'package:dungeons/game/combat.dart';
import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/spell_cast.dart';
import 'package:dungeons/game/value.dart';
import 'package:dungeons/game/weapon_attack.dart';
import 'package:dungeons/utility/dice.dart';
import 'package:dungeons/widget/colors.dart';
import 'package:dungeons/widget/dice_span.dart';
import 'package:dungeons/widget/percent_value.dart';
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
    return Text('$_current goes first.');
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
    final attacker = attack.attacker;
    final target = attack.target;
    return TextLines([
      _attacks(attack),
      _percentRoll('Attack', result.attackRoll, critical: result.isCriticalHit),
      if (result.deflected) Text('$target deflects the attack.'),
      if (result.rolledDodge) _percentRoll('Dodge', result.dodgeRoll),
      if (!result.canDodge) Text('$target cannot dodge.'),
      if (result.dodged) Text('$target dodges the attack.'),
      if (result.didDamage) ...[
        ..._diceRolls('${attacker.weapon}', result.damageRoll),
        _damageAndStatus(result.damageRoll, weaponTurn: turn),
      ],
    ]);
  }

  Widget _attacks(WeaponAttack attack) {
    final attacker = attack.attacker;
    final target = attack.target;
    return _richText(
      '$attacker ',
      TextSpan(
        text: attack.smite ? 'smites' : 'attacks',
        style: TextStyle(color: sourceColor(attack.source)),
      ),
      ' $target with ${attacker.weapon}.',
    );
  }

  Widget _spellTurn(SpellCastTurn turn) {
    final cast = turn.cast;
    final result = turn.result;
    final caster = cast.caster;
    final target = cast.target;
    return TextLines([
      _richText(
        '$caster casts ',
        SpellNameSpan(cast.spell),
        cast.self ? ' to self.' : ' at $target.',
      ),
      if (result.canResist) _percentRoll('Resist', result.resistRoll),
      if (result.resisted) Text('$target resists the spell.'),
      if (result.didHit && result.damageRoll != null)
        ..._spellDamage(result.damageRoll!, turn),
      if (result.didHit && result.healRoll != null)
        ..._spellHeal(result.healRoll!, cast),
    ]);
  }

  List<Widget> _spellDamage(DiceRollValue roll, SpellCastTurn turn) {
    return [
      ..._diceRolls(turn.cast.spell.text, roll),
      _damageAndStatus(roll, spellTurn: turn),
    ];
  }

  List<Widget> _spellHeal(DiceRollValue roll, SpellCast cast) {
    return [
      ..._diceRolls(cast.spell.text, roll),
      _richText(
        '${cast.target} is healed by ',
        DiceRollValueSpan(roll),
        '.',
      ),
    ];
  }

  Widget _damageAndStatus(
    DiceRollValue damage, {
    WeaponAttackTurn? weaponTurn,
    SpellCastTurn? spellTurn,
  }) {
    final target = weaponTurn?.attack.target ?? spellTurn!.cast.target;
    final source = weaponTurn?.attack.source ?? spellTurn!.cast.source;
    return _richText(
      '$target takes ',
      DamageSpan(damage, source),
      ' damage${_status(target, spellTurn)}.',
    );
  }

  Widget _diceRoll(String name, DiceRoll roll) {
    return _richText('$name roll ', DiceRollSpan(roll));
  }

  List<Widget> _diceRolls(String name, DiceRollValue value) {
    return [
      _diceRoll(name, value.base),
      for (final entry in value.diceBonuses)
        _diceRoll('${entry.bonus}', entry.value),
    ];
  }

  Widget _percentRoll(
    String name,
    PercentValueRoll roll, {
    bool critical = false,
  }) {
    return _richText(
      '$name roll ',
      PercentValueRollSpan(roll, critical: critical),
    );
  }

  String _status(Entity target, [SpellCastTurn? spellTurn]) {
    if (target.dead) {
      return ', and dies';
    }
    if (spellTurn?.result.didEffect == true) {
      final text = spellTurn?.cast.spell.effectText;
      if (text != null) {
        return ', and $text';
      }
    }
    return '';
  }

  Widget _xpText(int xp) {
    final player = combat.player;
    return Text('$player gains $xp XP'
        '${player.canLevelUpWith(xp) ? ', and levels up' : ''}.');
  }

  Widget _points(int points) {
    return TitledTextLines.plain(
      title: 'Choose attributes',
      lines: ['Points remaining: $points'],
    );
  }

  Widget _richText(String prefix, InlineSpan span, [String suffix = '']) {
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

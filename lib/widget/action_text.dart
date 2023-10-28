import 'package:dungeons/game/combat_action.dart';
import 'package:dungeons/game/spell_cast.dart';
import 'package:dungeons/game/value.dart';
import 'package:dungeons/game/weapon_attack.dart';
import 'package:dungeons/utility/dice.dart';
import 'package:dungeons/utility/if.dart';
import 'package:dungeons/widget/colors.dart';
import 'package:dungeons/widget/dice_span.dart';
import 'package:dungeons/widget/percent_value.dart';
import 'package:dungeons/widget/value_span.dart';
import 'package:flutter/widgets.dart';

class ActionText {
  final CombatAction _action;
  final ActionParameters _parameters;
  final ActionResult _result;

  const ActionText(this._action, this._parameters, this._result);

  List<Widget> get lines {
    if (_parameters is WeaponAttack) {
      final p = _parameters as WeaponAttack;
      return _weaponTurn(p, p.downcast(_result));
    }
    if (_parameters is SpellCast) {
      final p = _parameters as SpellCast;
      return _spellCast(p, p.downcast(_result));
    }
    throw ArgumentError.value(_parameters, "parameters");
  }

  List<Widget> _weaponTurn(WeaponAttack attack, WeaponAttackResult result) {
    final attacker = attack.attacker;
    final target = attack.target;
    return [
      _attacks(attack),
      _percentRoll('Attack', result.attackRoll, critical: result.isCriticalHit),
      if (result.deflected) Text('$target deflects the attack.'),
      if (result.rolledDodge) _percentRoll('Dodge', result.dodgeRoll),
      if (!result.canDodge) Text('$target cannot dodge.'),
      if (result.dodged) Text('$target dodges the attack.'),
      if (result.didDamage) ...[
        ..._diceRolls('${attacker.weapon}', result.damageRoll),
        _damageAndStatus(result.damageRoll),
      ],
    ];
  }

  Widget _attacks(WeaponAttack attack) {
    final attacker = attack.attacker;
    final target = attack.target;
    final offHand = ifdef(attack.twoWeaponAttack?.offHand, (offHand) {
      return ' and $offHand';
    });
    return _richText(
      '$attacker ',
      TextSpan(
        text: attack.smite ? 'smites' : 'attacks',
        style: TextStyle(color: sourceColor(attack.source)),
      ),
      ' $target with ${attacker.weapon}${offHand ?? ''}.',
    );
  }

  List<Widget> _spellCast(SpellCast cast, SpellCastResult result) {
    final caster = cast.caster;
    final target = cast.target;
    return [
      _richText(
        '$caster casts ',
        SpellNameSpan(cast.spell),
        cast.self ? ' to self.' : ' at $target.',
      ),
      if (result.canResist) _percentRoll('Resist', result.resistRoll),
      if (result.resisted) Text('$target resists the spell.'),
      if (result.didHit && result.damageRoll != null)
        ..._spellDamage(result.damageRoll!, cast),
      if (result.didHit && result.healRoll != null)
        ..._spellHeal(result.healRoll!, cast),
    ];
  }

  List<Widget> _spellDamage(DiceRollValue roll, SpellCast cast) {
    return [
      ..._diceRolls(cast.spell.text, roll),
      _damageAndStatus(roll),
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

  Widget _damageAndStatus(DiceRollValue damage) {
    return _richText(
      '${_parameters.target} takes ',
      DamageSpan(damage, _action.source),
      ' damage$_status.',
    );
  }

  String get _status {
    if (_parameters.target.dead) {
      return ', and dies';
    }
    if (_result.isSlowed) {
      return ', and is slowed';
    }
    return '';
  }
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


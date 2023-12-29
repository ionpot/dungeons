import "package:dungeons/game/action_input.dart";
import "package:dungeons/game/dice_value.dart";
import "package:dungeons/game/entity.dart";
import "package:dungeons/game/log.dart";
import "package:dungeons/game/smite.dart";
import "package:dungeons/game/spell_cast.dart";
import "package:dungeons/game/two_weapon_attack.dart";
import "package:dungeons/game/weapon_attack.dart";
import "package:dungeons/utility/dice.dart";
import "package:dungeons/widget/chance_roll.dart";
import "package:dungeons/widget/colors.dart";
import "package:dungeons/widget/dice_span.dart";
import "package:dungeons/widget/entity_span.dart";
import "package:flutter/widgets.dart";

class ActionText {
  final ActionResult _result;

  const ActionText(this._result);

  ActionInput get _input => _result.input;

  Entity get _actor => _input.actor;
  Entity get _target => _input.target;

  List<Widget> get lines {
    if (_result is WeaponAttackResult) {
      return _weaponTurn(_result as WeaponAttackResult);
    }
    if (_result is SpellCastResult) {
      return _spellCast(_result as SpellCastResult);
    }
    throw ArgumentError.value(_result, "result");
  }

  List<Widget> _weaponTurn(WeaponAttackResult result) {
    final input = result.input;
    return [
      _attacks(input),
      ChanceRollText(
        "Attack roll",
        input.hitChance,
        result.rolls.attack,
        critical: result.isCriticalHit,
      ),
      if (result.deflected) Text("$_target deflects the attack."),
      if (result.rolledDodge)
        ChanceRollText("Dodge roll", input.dodgeChance, result.rolls.dodge),
      if (!result.canDodge) Text("$_target cannot dodge."),
      if (result.dodged) Text("$_target dodges the attack."),
      if (result.didHit) ...[
        ..._diceRolls("${_actor.weapon}", result.rolls.damage),
        _damageAndStatus(result.rolls.damage),
        if (_target.alive) ..._effects,
      ],
    ];
  }

  Widget _attacks(WeaponAttackInput attack) {
    final offHand =
        attack is TwoWeaponAttackInput ? " and ${attack.offHand}" : "";
    return _richText(
      "$_actor ",
      TextSpan(
        text: attack is SmiteInput ? "smites" : "attacks",
        style: TextStyle(color: sourceColor(attack.source)),
      ),
      " $_target with ${_actor.weapon}$offHand.",
    );
  }

  List<Widget> _spellCast(SpellCastResult result) {
    final input = result.input;
    return [
      _richText(
        "$_actor casts ",
        SpellNameSpan(input.spell),
        input.targetSelf ? " to self." : " at $_target.",
      ),
      if (result.canResist)
        ChanceRollText("Resist roll", input.resistChance, result.rolls.resist),
      if (result.resisted) Text("$_target resists the spell."),
      if (result.didHit) ...[
        if (result.rolls.damage != null)
          ..._spellDamage(input, result.rolls.damage!),
        if (result.rolls.heal != null) ..._spellHeal(input, result.rolls.heal!),
        if (_target.alive) ..._effects,
      ],
    ];
  }

  List<Widget> _spellDamage(SpellCastInput input, DiceRoll roll) {
    return [
      _diceRoll(input.spell.text, roll),
      _damageAndStatus(DiceRollValue.from(roll)),
    ];
  }

  List<Widget> _spellHeal(SpellCastInput input, DiceRoll roll) {
    return [
      _diceRoll(input.spell.text, roll),
      Text("$_target is healed by ${roll.total}."),
    ];
  }

  Widget _damageAndStatus(DiceRollValue damage) {
    return _richText(
      "$_target takes ",
      DamageSpan(damage, _input.source),
      ' damage${_target.dead ? ', and dies' : ''}.',
    );
  }

  List<Widget> get _effects {
    final effects = [
      for (final entry in _input.effects) Log.effectText(entry.bonus),
    ];
    return [
      for (final text in effects)
        if (text.isNotEmpty) Text("$_target $text."),
    ];
  }
}

Widget _diceRoll(String name, DiceRoll roll) {
  return _richText("$name roll ", DiceRollSpan(roll));
}

List<Widget> _diceRolls(String name, DiceRollValue value) {
  return [
    _diceRoll(name, value.base),
    for (final entry in value.diceBonuses.entries)
      _diceRoll("${entry.key}", entry.value),
  ];
}

Widget _richText(String prefix, InlineSpan span, [String suffix = ""]) {
  return Text.rich(
    TextSpan(
      children: [
        TextSpan(text: prefix),
        span,
        if (suffix.isNotEmpty) TextSpan(text: suffix),
      ],
    ),
  );
}

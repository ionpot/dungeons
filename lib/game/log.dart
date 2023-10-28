import 'dart:io';

import 'package:dungeons/game/combat_action.dart';
import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/party.dart';
import 'package:dungeons/game/source.dart';
import 'package:dungeons/game/spell_cast.dart';
import 'package:dungeons/game/text.dart';
import 'package:dungeons/game/value.dart';
import 'package:dungeons/game/weapon_attack.dart';
import 'package:dungeons/utility/dice.dart';
import 'package:dungeons/utility/if.dart';

class Log {
  final IOSink file;

  const Log(this.file);

  Log.toFile(String name, {required String title})
      : this(File(name).openWrite()..writeln(title));

  void ln() => file.writeln();

  Future<void> end() async {
    await file.flush();
    await file.close();
  }

  void entity(Entity e, {required bool player}) {
    final damage = e.weaponDamage;
    final offHand = ifdef(e.gear.offHand, (offHand) {
      final armor = e.gear.shield?.armor;
      final dice = e.gear.offHandValue?.dice;
      return '$offHand (${armor ?? dice})';
    });
    file
      ..writeln('${e.name}, ${e.race} ${e.klass} Lv${e.level}')
      ..writeln('${e.attributes}')
      ..writeln('Hp ${e.totalHp}'
          '${player ? ', Stress Cap ${e.stressCap}' : ''}'
          '${player ? ', XP ${e.toXpString()}' : ''}')
      ..writeln('Initiative ${e.initiative}')
      ..writeln('Dodge ${e.dodge}, Resist ${e.resist}')
      ..writeln('Armor: ${e.totalArmor} (${e.armor})')
      ..writeln('Weapon: ${e.weapon} ($damage) ${damage?.range}')
      ..writeln('Off-hand: ${offHand ?? 'None'}');
  }

  void party(Party party, {bool player = false}) {
    for (final member in party) {
      entity(member.entity, player: player);
      ln();
    }
  }

  void actionResult(ActionParameters parameters, ActionResult result) {
    if (parameters is WeaponAttack) {
      return weaponAttack(parameters, parameters.downcast(result));
    }
    if (parameters is SpellCast) {
      return spellCast(parameters, parameters.downcast(result));
    }
  }

  void weaponAttack(WeaponAttack attack, WeaponAttackResult result) {
    final attacker = attack.attacker;
    final target = attack.target;
    final weapon = attacker.weapon!.text;
    final attackRoll = _percentRoll(
      result.attackRoll,
      critical: result.isCriticalHit,
    );
    final attacks = attack.smite ? 'smites' : 'attacks';
    final offHand = ifdef(attack.twoWeaponAttack?.offHand, (offHand) {
      return ' and $offHand';
    });
    file
      ..writeln('$attacker $attacks $target with $weapon${offHand ?? ''}.')
      ..writeln('Attack roll $attackRoll');
    if (result.deflected) {
      file.writeln('$target deflects the attack.');
      return;
    }
    if (result.rolledDodge) {
      file.writeln('Dodge roll ${_percentRoll(result.dodgeRoll)}');
    }
    if (!result.canDodge) {
      file.writeln('$target cannot dodge.');
    }
    if (result.dodged) {
      file.writeln('$target dodges the attack.');
      return;
    }
    _writeDiceRolls(weapon, result.damageRoll);
    _writeDamage(target, result.damageRoll, attack.source);
    _writeStatus(target, result);
  }

  void spellCast(SpellCast cast, SpellCastResult result) {
    final caster = cast.caster;
    final target = cast.target;
    final spell = cast.spell;
    file
      ..write('$caster casts $spell ')
      ..writeln(cast.self ? 'to self.' : 'at $target.');
    if (result.canResist) {
      file.writeln('Resist ${_percentRoll(result.resistRoll)}');
    }
    if (result.resisted) {
      file.writeln('$target resists the spell.');
      return;
    }
    ifdef(result.healRoll, (healRoll) {
      _writeDiceRolls(spell.text, healRoll);
      file.writeln('$target is healed by $healRoll.');
    });
    ifdef(result.damageRoll, (damageRoll) {
      _writeDiceRolls(spell.text, damageRoll);
      _writeDamage(target, damageRoll, spell.source);
      _writeStatus(target, result);
    });
  }

  void newRound(int round) {
    file.writeln('Round $round');
  }

  void xpGain(PartyXpGain xpGain) {
    for (final member in xpGain) {
      final xp = xpGain.amount(member);
      file.writeln(xpGainText(member.entity, xp));
    }
  }

  String _percentRoll(PercentValueRoll roll, {bool critical = false}) {
    return '(${roll.input}) ${roll.result.text(critical)}';
  }

  void _writeDamage(Entity target, DiceRollValue damage, Source source) {
    file.write('$target takes $damage ${source.name} damage');
  }

  void _writeDiceRoll(String name, DiceRoll value) {
    file.writeln('$name roll (${value.dice.base}) $value');
  }

  void _writeDiceRolls(String rollName, DiceRollValue value) {
    _writeDiceRoll(rollName, value.base);
    for (final entry in value.diceBonuses) {
      _writeDiceRoll('${entry.bonus}', entry.value);
    }
  }

  void _writeStatus(Entity target, ActionResult result) {
    if (target.dead) {
      file.writeln(', and dies.');
    } else if (result.isSlowed) {
      file.writeln(', and is slowed.');
    }
  }
}

import "dart:io";

import "package:dungeons/game/combat/action_input.dart";
import "package:dungeons/game/combat/chance_roll.dart";
import "package:dungeons/game/combat/party.dart";
import "package:dungeons/game/combat/smite.dart";
import "package:dungeons/game/combat/spell_cast.dart";
import "package:dungeons/game/combat/two_weapon_attack.dart";
import "package:dungeons/game/combat/weapon_attack.dart";
import "package:dungeons/game/entity.dart";
import "package:dungeons/game/entity/dice_value.dart";
import "package:dungeons/game/entity/value.dart";
import "package:dungeons/game/text.dart";
import "package:dungeons/utility/dice.dart";
import "package:dungeons/utility/if.dart";
import "package:dungeons/utility/monoids.dart";

class Log {
  final IOSink file;

  const Log(this.file);

  Log.toFile(String name, {required String title})
      : this(File(name).openWrite()..writeln(title));

  void ln([Object? o = ""]) => file.writeln(o);

  Future<void> end() async {
    await file.flush();
    await file.close();
  }

  void entity(Entity e, {required bool player}) {
    final damage = e.weaponDamage;
    ln("${e.name}, ${e.race} ${e.klass} Lv${e.level}");
    ln("${e.attributes}");
    ln("Hp ${e.totalHp}"
        '${player ? ', Stress Cap ${e.stressCap}' : ''}'
        '${player ? ', XP ${e.toXpString()}' : ''}');
    ln("Initiative ${e.initiative}");
    ln("Dodge ${e.dodge}, Resist ${e.resist}");
    ln("Armor: ${e.armorValue} (${e.armor})");
    ln("Weapon: ${e.weapon} ($damage) ${damage?.range}");
    ln("Off-hand: ${offHandText(e)}");
  }

  void party(Party party, {bool player = false}) {
    for (final member in party) {
      entity(member.entity, player: player);
      ln();
    }
  }

  void actionResult(ActionResult result) {
    if (result is WeaponAttackResult) {
      return weaponAttack(result.input, result);
    }
    if (result is SpellCastResult) {
      return spellCast(result.input, result);
    }
  }

  void weaponAttack(WeaponAttackInput input, WeaponAttackResult result) {
    final attacker = input.actor;
    final target = input.target;
    final weapon = attacker.weapon!.text;
    final attackRoll = _chanceRoll(
      result.rolls.attack,
      input.hitChance,
      critical: result.isCriticalHit,
    );
    final attacks = input is SmiteInput ? "smites" : "attacks";
    final offHand =
        input is TwoWeaponAttackInput ? " and ${input.offHand}" : "";
    ln("$attacker $attacks $target with $weapon$offHand.");
    ln("Attack roll $attackRoll");
    if (result.deflected) {
      ln("$target deflects the attack.");
      return;
    }
    if (result.rolledDodge) {
      final str = _chanceRoll(result.rolls.dodge, input.dodgeChance);
      ln("Dodge roll $str");
    }
    if (!result.canDodge) {
      ln("$target cannot dodge.");
    }
    if (result.dodged) {
      ln("$target dodges the attack.");
      return;
    }
    _writeDiceRolls(weapon, result.rolls.damage);
    _writeResult(result, input);
  }

  void spellCast(SpellCastInput input, SpellCastResult result) {
    final caster = input.caster;
    final target = input.target;
    final spell = input.spell;
    file.write("$caster casts $spell ");
    ln(input.targetSelf ? "to self." : "at $target.");
    if (result.canResist) {
      ln("Resist ${_chanceRoll(result.rolls.resist, input.resistChance)}");
    }
    if (result.resisted) {
      ln("$target resists the spell.");
      return;
    }
    ifdef(result.rolls.heal, (healRoll) {
      _writeDiceRoll(spell.text, healRoll);
    });
    ifdef(result.rolls.damage, (damageRoll) {
      _writeDiceRolls(spell.text, damageRoll);
    });
    _writeResult(result, input);
  }

  void newRound(int round) {
    ln("Round $round");
  }

  void xpGain(PartyXpGain xpGain) {
    for (final PartyMember(:entity) in xpGain) {
      ln(xpGainText(entity, xpGain.amount(entity)));
    }
  }

  void _writeResult(ActionResult result, ActionInput params) {
    final target = params.target;
    if (result.healingDone != 0) {
      ln("$target is healed by ${result.healingDone}.");
      return;
    }
    if (result.damageDone != 0) {
      ln("$target takes ${result.damageDone}"
          " ${params.source.name} damage.");
      if (target.dead) {
        ln("$target dies.");
      }
    }
    if (target.alive) {
      for (final entry in result.effects) {
        final text = effectText(entry.value);
        if (text.isNotEmpty) {
          ln("$target $text.");
        }
      }
    }
  }

  void _writeDiceRoll(String name, DiceRoll value) {
    ln("$name roll (${value.dice.base}) $value");
  }

  void _writeDiceRolls(String rollName, DiceRollValue value) {
    _writeDiceRoll(rollName, value.base);
    for (final entry in value.diceBonuses.entries) {
      _writeDiceRoll("${entry.key}", entry.value);
    }
  }

  static String _chanceRoll(
    ChanceRoll roll,
    Value<Percent> value, {
    bool critical = false,
  }) {
    return "($value) ${chanceRollText(roll, value.total, critical)}";
  }
}

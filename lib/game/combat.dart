import 'dart:collection';
import 'dart:math';

import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/spell.dart';
import 'package:dungeons/game/spell_attack.dart';
import 'package:dungeons/game/weapon_attack.dart';
import 'package:dungeons/utility/if.dart';

class Combat {
  final Entity player;
  final Entity enemy;
  Queue<Entity> _queue = Queue();
  int _round = 1;

  Combat(this.player, this.enemy) {
    resetQueue();
  }

  factory Combat.withPlayer(Entity player) {
    player
      ..resetHp()
      ..clearStress()
      ..clearSpellEffects();
    return Combat(player, player.rollEnemy());
  }

  void resetQueue() {
    _queue = Queue.from(
      player.fasterThan(enemy) ? [player, enemy] : [enemy, player],
    );
  }

  bool get ended => player.dead || enemy.dead;
  bool get won => ended && enemy.dead;
  bool get lost => ended && player.dead;

  bool get newRound => _queue.isEmpty;
  int get round => _round;

  Entity get current => _queue.first;
  Entity get other => current == player ? enemy : player;

  CombatAction randomAction() {
    final spells = current.knownSpells;
    final len = spells.length;
    final i = Random().nextInt(len + 1);
    return i < len ? CombatAction(castSpell: spells[i]) : const CombatAction();
  }

  CombatTurn toTurn(CombatAction action) =>
      ifdef(action.castSpell, (spell) {
        return CombatTurn.spell(
          SpellAttack(spell, from: current, target: other),
        );
      }) ??
      CombatTurn.weapon(
        WeaponAttack(from: current, target: other),
      );

  void nextTurn() {
    _queue.removeFirst();
    if (newRound) {
      ++_round;
      resetQueue();
    }
  }

  void activateSkills() {
    player.activateSkill();
    enemy.activateSkill();
  }

  int get xpGain => player.xpGain(enemy);

  bool get xpGained => player.alive && enemy.dead;

  void addXp() {
    player.xp += xpGain;
  }

  bool canLevelUp() => player.canLevelUpWith(xpGain);
}

class CombatAction {
  final Spell? castSpell;

  const CombatAction({this.castSpell});
}

class CombatTurn {
  final WeaponAttackTurn? weaponTurn;
  final SpellAttackTurn? spellTurn;

  const CombatTurn({this.weaponTurn, this.spellTurn});

  factory CombatTurn.weapon(WeaponAttack attack) {
    return CombatTurn(weaponTurn: WeaponAttackTurn(attack));
  }

  factory CombatTurn.spell(SpellAttack attack) {
    return CombatTurn(spellTurn: SpellAttackTurn(attack));
  }

  void apply() {
    weaponTurn?.apply();
    spellTurn?.apply();
  }
}

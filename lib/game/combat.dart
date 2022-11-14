import 'dart:collection';
import 'dart:math';

import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/entity_class.dart';
import 'package:dungeons/game/spell.dart';
import 'package:dungeons/game/spell_cast.dart';
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
    _queue = Queue.from([_faster, _otherOf(_faster)]);
  }

  bool get ended => player.dead || enemy.dead;
  bool get won => ended && enemy.dead;
  bool get lost => ended && player.dead;

  bool get newRound => _queue.isEmpty;
  int get round => _round;

  Entity get current => _queue.first;
  Entity get next => _queue.length == 2 ? _queue.last : _faster;

  Entity get _faster => player.fasterThan(enemy) ? player : enemy;
  Entity get _other => _otherOf(current);
  Entity _otherOf(Entity e) => e == player ? enemy : player;

  CombatAction randomAction() {
    switch (current.klass) {
      case EntityClass.warrior:
      case EntityClass.trickster:
        return CombatAction(target: _other);
      case EntityClass.cleric:
        return _clericAction;
      case EntityClass.mage:
        return _mageAction;
    }
  }

  CombatAction get _clericAction {
    if (!current.hasSpellEffect(Spell.bless)) {
      return CombatAction(target: current, castSpell: Spell.bless);
    }
    if (current.injured && Random().nextBool()) {
      return CombatAction(target: current, castSpell: Spell.heal);
    }
    return CombatAction(target: _other);
  }

  CombatAction get _mageAction {
    final spells = current.knownSpells;
    final len = spells.length;
    final i = Random().nextInt(len + 1);
    return CombatAction(
      target: _other,
      castSpell: i < len ? spells[i] : null,
    );
  }

  CombatTurn toTurn(CombatAction action) =>
      ifdef(action.castSpell, (spell) {
        return CombatTurn.spell(
          SpellCast(
            spell,
            from: current,
            target: action.target,
          ),
        );
      }) ??
      CombatTurn.weapon(
        WeaponAttack(from: current, target: action.target),
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

  bool canGainXp() => player.alive && enemy.dead;

  void addXp() {
    player.xp += xpGain;
  }

  bool canLevelUp() => player.canLevelUpWith(xpGain);
}

class CombatAction {
  final Entity target;
  final Spell? castSpell;

  const CombatAction({required this.target, this.castSpell});
}

class CombatTurn {
  final WeaponAttackTurn? weaponTurn;
  final SpellCastTurn? spellTurn;

  const CombatTurn({this.weaponTurn, this.spellTurn});

  factory CombatTurn.weapon(WeaponAttack attack) {
    return CombatTurn(weaponTurn: WeaponAttackTurn(attack, attack.roll()));
  }

  factory CombatTurn.spell(SpellCast cast) {
    return CombatTurn(spellTurn: SpellCastTurn(cast, cast.roll()));
  }

  void apply() {
    weaponTurn?.apply();
    spellTurn?.apply();
  }
}

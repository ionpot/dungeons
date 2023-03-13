import 'dart:collection';
import 'dart:math';

import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/entity_class.dart';
import 'package:dungeons/game/smite.dart';
import 'package:dungeons/game/spell.dart';
import 'package:dungeons/game/spell_cast.dart';
import 'package:dungeons/game/weapon_attack.dart';

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
      ..clearSpellBonuses();
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

  bool maybe() => Random().nextBool();

  CombatAction randomAction() {
    switch (current.klass) {
      case EntityClass.warrior:
      case EntityClass.trickster:
        return CombatAction(
          target: _other,
          useOffHand: TwoWeaponAttack.possible(current) && maybe(),
        );
      case EntityClass.cleric:
        return _clericAction;
      case EntityClass.mage:
        return _mageAction;
      case null:
        throw ArgumentError.notNull('current.klass');
    }
  }

  CombatAction get _clericAction {
    if (!current.hasSpellBonus(Spell.bless)) {
      return CombatAction(target: current, castSpell: Spell.bless);
    }
    if (current.injured && maybe()) {
      return CombatAction(target: current, castSpell: Spell.heal);
    }
    return CombatAction(
      target: _other,
      smite: Smite.possible(current) && maybe(),
    );
  }

  CombatAction get _mageAction {
    return CombatAction(
      target: _other,
      castSpell: current.maybeRandomSpell(),
    );
  }

  CombatTurn toTurn(CombatAction action) {
    if (action.castSpell != null) {
      return CombatTurn.spell(
        SpellCast(
          action.castSpell!,
          caster: current,
          target: action.target,
        ),
      );
    }
    return CombatTurn.weapon(
      WeaponAttack(
        attacker: current,
        target: action.target,
        smite: action.smite,
        useOffHand: action.useOffHand,
      ),
    );
  }

  void nextTurn() {
    _queue.removeFirst();
    if (newRound) {
      ++_round;
      resetQueue();
    }
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
  final bool smite;
  final bool useOffHand;

  const CombatAction({
    required this.target,
    this.castSpell,
    this.smite = false,
    this.useOffHand = false,
  });
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

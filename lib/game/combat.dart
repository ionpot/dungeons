import 'dart:math';

import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/entity_class.dart';
import 'package:dungeons/game/party.dart';
import 'package:dungeons/game/smite.dart';
import 'package:dungeons/game/spell.dart';
import 'package:dungeons/game/spell_cast.dart';
import 'package:dungeons/game/weapon_attack.dart';

class Combat {
  final Party player;
  final Party enemy;
  final Set<Entity> _played = {};
  int _round = 1;

  Combat(this.player, this.enemy);

  factory Combat.withPlayer(Entity player) {
    player
      ..resetHp()
      ..clearStress()
      ..clearSpellBonuses();
    return Combat(
      Party.single(player),
      Party.single(player.rollEnemy()),
    );
  }

  int compareSpeed(Entity a, Entity b) {
    final i = a.compareSpeed(b);
    if (i == 0) {
      return isPlayer(a) ? -1 : 1;
    }
    return i;
  }

  List<Entity> get participants {
    return <Entity>[...player.list, ...enemy.list];
  }

  List<Entity> get alive {
    return <Entity>[
      for (final entity in participants)
        if (entity.alive) entity,
    ];
  }

  List<Entity> get turnOrder => alive..sort(compareSpeed);
  List<Entity> get notPlayed => turnOrder..removeWhere(_played.contains);

  bool get won => player.isAlive && enemy.isDead;
  bool get lost => player.isDead;

  bool get newRound => _played.isEmpty;
  int get round => _round;

  Entity get current => notPlayed.first;
  Entity get next => notPlayed.length == 2 ? notPlayed.last : turnOrder.first;

  PartyXpGain get xpGain => player.xpGain(enemy);
  Entity? get hasExtraPoints => player.hasExtraPoints;

  Entity enemyOf(Entity entity) => alive.firstWhere((e) => e != entity);

  bool isPlayer(Entity entity) => player.hasEntity(entity);

  bool maybe() => Random().nextBool();

  CombatAction randomAction() {
    switch (current.klass!) {
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
    }
  }

  Entity get _other => enemyOf(current);

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
    _played.add(notPlayed.first);
    if (notPlayed.isEmpty) {
      _played.clear();
      ++_round;
    }
  }
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

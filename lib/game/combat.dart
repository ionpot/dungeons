import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/spell.dart';
import 'package:dungeons/game/spell_attack.dart';
import 'package:dungeons/game/weapon_attack.dart';

class Combat {
  final Entity player;
  final Entity enemy;
  final Entity first;
  Entity _current;
  int _round = 1;

  Combat(this.player, this.enemy, this.first) : _current = first;

  factory Combat.withPlayer(Entity player) {
    player
      ..resetHp()
      ..clearStress()
      ..clearSpellEffects();
    final enemy = player.rollEnemy();
    final first = player.fasterThan(enemy) ? player : enemy;
    return Combat(player, enemy, first);
  }

  bool get ended => player.dead || enemy.dead;

  bool get newRound => _current == first;
  int get round => _round;
  Entity get current => _current;

  CombatTurn doTurn() {
    const spell = Spell.rayOfFrost;
    if (current.canCast(spell)) {
      final attack = SpellAttack(spell, from: _current, target: _other);
      return CombatTurn.spell(attack);
    }
    final attack = WeaponAttack(from: _current, target: _other);
    return CombatTurn.weapon(attack);
  }

  void next() {
    _current = _other;
    if (newRound) ++_round;
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

  Entity get _other => (_current == player) ? enemy : player;
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

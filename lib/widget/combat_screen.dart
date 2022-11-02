import 'dart:io';

import 'package:dungeons/game/attack.dart';
import 'package:dungeons/game/combat.dart';
import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/entity_attr.dart';
import 'package:dungeons/game/log.dart';
import 'package:dungeons/widget/combat_attack.dart';
import 'package:dungeons/widget/combat_level.dart';
import 'package:dungeons/widget/combat_start.dart';
import 'package:dungeons/widget/entity_stats.dart';
import 'package:dungeons/widget/spaced.dart';
import 'package:flutter/widgets.dart';

class CombatScreen extends StatefulWidget {
  final Combat combat;
  final Log log;
  final VoidCallback onWin;
  final VoidCallback onLose;

  const CombatScreen(
    this.combat, {
    super.key,
    required this.log,
    required this.onWin,
    required this.onLose,
  });

  factory CombatScreen.withPlayer(
    Entity player, {
    required Log log,
    required VoidCallback onWin,
    required VoidCallback onLose,
    Key? key,
  }) =>
      CombatScreen(
        Combat.withPlayer(player),
        log: log,
        onWin: onWin,
        onLose: onLose,
        key: key,
      );

  @override
  State<CombatScreen> createState() => _CombatScreenState();
}

class _CombatScreenState extends State<CombatScreen> {
  bool _started = false;
  Attack? _attack;

  Combat get _combat => widget.combat;
  Entity get _player => _combat.player;
  Log get _log => widget.log..ln();
  IOSink get _logFile => widget.log.file;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      child: buildSpacedColumn(
        children: [
          Row(
            children: [
              SizedBox(
                width: 300,
                child: EntityStats(_combat.player),
              ),
              EntityStats(_combat.enemy),
            ],
          ),
          _secondRow,
        ],
      ),
    );
  }

  Widget get _secondRow {
    if (!_started) {
      return CombatStart(_combat, onDone: _onStart);
    }
    if (_player.extraPoints > 0) {
      return CombatLevel(_player.extraPoints, onPoint: _onAttributePoint);
    }
    if (_attack != null) {
      return CombatAttack(_combat, _attack!, onDone: _onNext);
    }
    throw Exception('Invalid combat state.');
  }

  void _onStart() {
    _log
      ..file.writeln('New combat')
      ..ln()
      ..entity(_combat.player)
      ..ln()
      ..entity(_combat.enemy);
    setState(() {
      _started = true;
      _combat.activateSkills();
    });
    _doAttack();
  }

  void _onNext() {
    if (_combat.ended) {
      return _doEnd();
    }
    setState(() => _combat.next());
    _doAttack();
  }

  void _onAttributePoint(EntityAttributeId id) {
    setState(() {
      _player.spendPointTo(id);
    });
    if (_player.extraPoints == 0) {
      return widget.onWin();
    }
  }

  void _doAttack() {
    if (_combat.newRound) {
      _log.newRound(_combat.round);
    }
    setState(() {
      _attack = _combat.attack()..apply();
    });
    _log.attack(_attack!);
  }

  void _doEnd() {
    if (_player.dead) {
      return widget.onLose();
    }
    setState(() {
      _combat.addXp();
      _logFile.writeln('${_player.name} gains ${_combat.xpGain} XP'
          '${_player.canLevelUp() ? ', and levels up' : ''}.');
      _player.tryLevelUp();
    });
    if (_player.extraPoints == 0) {
      return widget.onWin();
    }
  }
}

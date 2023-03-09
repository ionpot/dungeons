import 'package:dungeons/game/combat.dart';
import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/entity_attr.dart';
import 'package:dungeons/game/log.dart';
import 'package:dungeons/widget/sized_wrap.dart';
import 'package:dungeons/widget/combat_buttons.dart';
import 'package:dungeons/widget/combat_display.dart';
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

  @override
  State<CombatScreen> createState() => _CombatScreenState();
}

class _CombatScreenState extends State<CombatScreen> {
  CombatTurn? _turn;

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
          Wrap(
            children: [
              SizedWrap(
                width: 160,
                child: CombatButtons(
                  _combat,
                  turn: _turn == null ? _combat.current : _combat.next,
                  onPlayerAction: _onAction,
                  onEnemyAction: () => _onAction(null),
                  onWin: _onWin,
                  onLose: widget.onLose,
                  onAttributePoint: _onAttributePoint,
                ),
              ),
              CombatDisplay(_turn, _combat),
            ],
          ),
        ],
      ),
    );
  }

  Combat get _combat => widget.combat;
  Entity get _player => _combat.player;
  Log get _log => widget.log..ln();

  void _onStart() {
    _log
      ..file.writeln('New combat')
      ..ln()
      ..entity(_combat.player)
      ..ln()
      ..entity(_combat.enemy);
  }

  void _onAction(CombatAction? action) {
    if (_turn == null) {
      _onStart();
    } else {
      setState(_combat.nextTurn);
    }
    if (_combat.newRound) {
      _log.newRound(_combat.round);
    }
    setState(() {
      _turn = _combat.toTurn(action ?? _combat.randomAction());
      _turn!.apply();
    });
    _log.combatTurn(_turn!);
  }

  void _onAttributePoint(EntityAttributeId id) {
    setState(() {
      _player.spendPointTo(id);
    });
    if (_player.extraPoints == 0 && _combat.won) {
      return widget.onWin();
    }
  }

  void _onWin() {
    widget.log.xpGain(_combat);
    setState(() {
      _combat.addXp();
      _player.tryLevelUp();
    });
    if (_player.extraPoints == 0) {
      return widget.onWin();
    }
  }
}

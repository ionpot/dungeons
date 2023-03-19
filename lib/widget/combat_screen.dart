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
              for (final entity in _combat.participants)
                SizedBox(
                  width: 300,
                  child: EntityStats(entity, player: _combat.isPlayer(entity)),
                ),
            ],
          ),
          Wrap(
            children: [
              SizedWrap(
                width: 180,
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
  Log get _log => widget.log..ln();

  void _onStart() {
    _log.file.writeln('New combat');
    for (final entity in _combat.participants) {
      _log
        ..ln()
        ..entity(entity, player: _combat.isPlayer(entity));
    }
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

  void _onAttributePoint(EntityAttributeId id, Entity entity) {
    setState(() {
      entity.spendPointTo(id);
    });
    if (_combat.hasExtraPoints == null && _combat.won) {
      return widget.onWin();
    }
  }

  void _onWin() {
    final xpGain = _combat.xpGain;
    widget.log.xpGain(xpGain);
    setState(() {
      xpGain.apply();
    });
    if (_combat.hasExtraPoints == null) {
      return widget.onWin();
    }
  }
}

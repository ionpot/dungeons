import "package:dungeons/game/chosen_action.dart";
import "package:dungeons/game/combat.dart";
import "package:dungeons/game/combat_action.dart";
import "package:dungeons/game/combat_grid.dart";
import "package:dungeons/game/entity.dart";
import "package:dungeons/game/log.dart";
import "package:dungeons/widget/combat_layout.dart";
import "package:dungeons/widget/combat_phase.dart";
import "package:dungeons/widget/entity_portrait.dart";
import "package:dungeons/widget/entity_stats.dart";
import "package:dungeons/widget/top_left.dart";
import "package:flutter/widgets.dart";

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
  State<StatefulWidget> createState() => _CombatScreenState();
}

class _CombatScreenState extends State<CombatScreen> {
  late CombatPhase _phase;
  GridMember? _leftMember;
  GridMember? _rightMember;

  @override
  void initState() {
    super.initState();
    _phase = _startingPhase();
    _leftMember = _grid.firstPlayer;
    _rightMember = _grid.firstEnemy;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset("image/combat_bg.png"),
        for (final member in _grid)
          TopLeft(
            _grid.isPlayer(member)
                ? playerPartySlotOffset(member.position)
                : enemyPartySlotOffset(member.position),
            child: _toPortrait(member),
          ),
        TopLeft(buttonsOffset, child: _phase.buttons),
        TopLeft(displayOffset, child: _phase.display),
        if (_leftMember != null)
          TopLeft(
            leftStatsOffset,
            child: _entityStats(_leftMember!),
          ),
        if (_rightMember != null)
          TopLeft(
            rightStatsOffset,
            child: _entityStats(_rightMember!),
          ),
      ],
    );
  }

  Combat get _combat => widget.combat;
  CombatGrid get _grid => _combat.grid;
  GridMember get _current => _combat.current;
  Log get _log => widget.log;

  CombatPhase _startingPhase() {
    _log
      ..ln()
      ..ln("New Combat")
      ..ln()
      ..party(_grid.player, player: true)
      ..ln("Enemy")
      ..ln()
      ..party(_grid.enemy)
      ..newRound(_combat.round);
    _setCurrentStats();
    return StartingPhase(
      first: _current.entity,
      onNext: _doAction,
    );
  }

  CombatPhase _actionPhase() {
    return ActionSelectPhase(
      actor: _current,
      onChosen: (action) {
        _setPhase(_targetingPhase(action));
      },
    );
  }

  CombatPhase _targetingPhase(CombatAction action) {
    return TargetingPhase(
      _combat,
      action,
      onChosen: (target) {
        _setPhase(_actionResultPhase(ChosenAction(action, target)));
      },
      onCancel: () {
        _setPhase(_actionPhase());
      },
    );
  }

  void _doAction() {
    if (_combat.isPlayerTurn) {
      _setPhase(_actionPhase());
    } else {
      final action = _combat.randomAction();
      final phase =
          action == null ? _noActionPhase() : _actionResultPhase(action);
      _setPhase(phase);
    }
  }

  void _newTurn() {
    setState(() {
      _combat.nextTurn();
    });
    if (_combat.newRound) {
      _log
        ..ln()
        ..newRound(_combat.round);
    }
    _setCurrentStats();
    _doAction();
  }

  CombatPhase _noActionPhase() {
    return NoActionPhase(_combat, onNext: () {
      _log
        ..ln()
        ..ln("${_combat.current} does nothing.");
      _newTurn();
    });
  }

  CombatPhase _actionResultPhase(ChosenAction chosen) {
    final result = chosen.toResult();
    chosen.apply(result);
    _log
      ..ln()
      ..actionResult(chosen.parameters, result);
    return ActionResultPhase(
      _combat,
      action: chosen.action,
      parameters: chosen.parameters,
      result: result,
      onDone: () {
        if (_combat.won) {
          return _setPhase(_xpPhase());
        }
        if (_combat.lost) {
          return widget.onLose();
        }
        _newTurn();
      },
    );
  }

  CombatPhase _xpPhase() {
    _log
      ..ln()
      ..xpGain(_combat.xpGain);
    return XpGainPhase(
      _combat,
      onDone: () {
        setState(() {
          _combat.xpGain.apply();
        });
        _onWin();
      },
    );
  }

  CombatPhase _levelUpPhase(Entity entity) {
    return LevelUpPhase(
      entity,
      onAttribute: (id) {
        setState(() {
          entity.spendPointTo(id);
        });
        if (entity.extraPoints == 0) {
          _onWin();
        }
      },
    );
  }

  void _onWin() {
    for (final member in _combat.xpGain) {
      if (member.entity.hasPointsToSpend) {
        return _setPhase(_levelUpPhase(member.entity));
      }
    }
    widget.onWin();
  }

  void _setPhase(CombatPhase phase) {
    setState(() {
      _phase = phase;
    });
  }

  void _setCurrentStats() {
    setState(() {
      if (_combat.isPlayerTurn) {
        _leftMember = _current;
      } else {
        _rightMember = _current;
      }
    });
  }

  EntityPortrait _toPortrait(GridMember member) {
    final args = _phase.portraitArgs(member);
    return EntityPortrait(
      member.entity,
      current: args.current ?? member == _current,
      onMouseClick: args.onClick,
      targeting: args.targeting,
      onMouseEnter: () {
        setState(() {
          if (_combat.isPlayerTurn) {
            _rightMember = member;
          } else {
            _leftMember = member;
          }
        });
      },
    );
  }

  EntityStats _entityStats(GridMember member) {
    return EntityStats(
      member.entity,
      isPlayer: _combat.isPlayer(member),
    );
  }
}

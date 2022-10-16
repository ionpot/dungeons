import 'package:dungeons/game/attack.dart';
import 'package:dungeons/game/combat.dart';
import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/log.dart';
import 'package:dungeons/utility/value_callback.dart';
import 'package:dungeons/widget/attack_text.dart';
import 'package:dungeons/widget/button.dart';
import 'package:dungeons/widget/entity_stats.dart';
import 'package:dungeons/widget/section.dart';
import 'package:flutter/widgets.dart';

class CombatScreen extends StatefulWidget {
  final Combat combat;
  final Log log;
  final ValueCallback<Entity> onDone;

  const CombatScreen(
    this.combat, {
    super.key,
    required this.log,
    required this.onDone,
  });

  factory CombatScreen.withPlayer(
    Entity player, {
    required Log log,
    required ValueCallback<Entity> onDone,
    Key? key,
  }) =>
      CombatScreen(
        Combat(player),
        log: log,
        onDone: onDone,
        key: key,
      );

  @override
  State<CombatScreen> createState() => _CombatScreenState();
}

class _CombatScreenState extends State<CombatScreen> {
  late Combat _combat;
  late int _round;
  Attack? _attack;
  late final int _xpGain;

  @override
  void initState() {
    super.initState();
    _combat = widget.combat;
    _round = _combat.round;
    _xpGain = _combat.xpGain;
    widget.log
      ..ln()
      ..file.writeln('New combat')
      ..ln()
      ..entity(_combat.player)
      ..ln()
      ..entity(_combat.enemy);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
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
          Section.below(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Button(text: 'Next', onClick: _onNext),
                Section.after(
                  child: (_attack != null)
                      ? AttackText(_attack!, round: _round, xpGain: _xpGain)
                      : Text('${_combat.turn.name} goes first.'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onNext() {
    final player = _combat.player;
    if (_combat.ended) {
      if (player.isAlive()) {
        player.xp += _xpGain;
        widget.log.file.writeln('${player.name} gains $_xpGain XP'
            '${player.canLevelUp() ? ', and levels up' : ''}.');
        player.tryLevelUp();
        player.resetHp();
      }
      return widget.onDone(player);
    }
    setState(() {
      _round = _combat.round;
      if (_combat.newRound) {
        widget.log
          ..ln()
          ..newRound(_combat.round);
      }
      _attack = _combat.attack()..apply();
      _combat.next();
      widget.log
        ..ln()
        ..attack(_attack!);
    });
  }
}

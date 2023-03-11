import 'package:dungeons/game/combat.dart';
import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/entity_attr.dart';
import 'package:dungeons/utility/value_callback.dart';
import 'package:dungeons/widget/action_select.dart';
import 'package:dungeons/widget/attribute_select.dart';
import 'package:dungeons/widget/button.dart';
import 'package:flutter/widgets.dart';

class CombatButtons extends StatelessWidget {
  final Entity turn;
  final Combat combat;
  final ValueCallback<CombatAction> onPlayerAction;
  final VoidCallback onEnemyAction;
  final VoidCallback onWin;
  final VoidCallback onLose;
  final ValueCallback<EntityAttributeId> onAttributePoint;

  const CombatButtons(
    this.combat, {
    super.key,
    required this.turn,
    required this.onPlayerAction,
    required this.onEnemyAction,
    required this.onWin,
    required this.onLose,
    required this.onAttributePoint,
  });

  @override
  Widget build(BuildContext context) {
    if (combat.player.extraPoints > 0) {
      return AttributeSelect(onChosen: onAttributePoint);
    }
    if (combat.won) {
      return Button(
        text: combat.canLevelUp() ? 'Level Up' : 'Next',
        onClick: onWin,
      );
    }
    if (combat.lost) {
      return Button(text: 'End', onClick: onLose);
    }
    if (turn.player) {
      return ActionSelect(turn, combat.enemy, onChosen: onPlayerAction);
    }
    return Button(text: 'Next', onClick: onEnemyAction);
  }
}

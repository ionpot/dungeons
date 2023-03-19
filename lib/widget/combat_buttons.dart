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
  final void Function(EntityAttributeId, Entity) onAttributePoint;

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
    if (combat.hasExtraPoints != null) {
      return AttributeSelect(
        onChosen: (id) => onAttributePoint(id, combat.hasExtraPoints!),
      );
    }
    if (combat.won) {
      return Button(
        text: combat.xpGain.canLevelUp ? 'Level Up' : 'Next',
        onClick: onWin,
      );
    }
    if (combat.lost) {
      return Button(text: 'End', onClick: onLose);
    }
    if (combat.isPlayer(turn)) {
      return ActionSelect(turn, combat.enemyOf(turn), onChosen: onPlayerAction);
    }
    return Button(text: 'Next', onClick: onEnemyAction);
  }
}

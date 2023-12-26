import "package:dungeons/game/action_input.dart";
import "package:dungeons/game/combat_action.dart";
import "package:dungeons/game/combat_grid.dart";

class ChosenAction {
  final CombatAction action;
  final GridMember target;

  const ChosenAction(this.action, this.target);

  ActionInput get parameters => action.input(target);

  ActionResult toResult() => action.result(parameters);
}

import "package:dungeons/game/combat/action.dart";
import "package:dungeons/game/combat/action_input.dart";
import "package:dungeons/game/combat/grid.dart";

class ChosenAction {
  final CombatAction action;
  final GridMember target;

  const ChosenAction(this.action, this.target);

  ActionInput get parameters => action.input(target);

  ActionResult toResult() => action.result(parameters);
}

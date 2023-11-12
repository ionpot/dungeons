import "package:dungeons/game/action_parameters.dart";
import "package:dungeons/game/combat_action.dart";
import "package:dungeons/game/combat_grid.dart";

class ChosenAction {
  final CombatAction action;
  final GridMember target;

  const ChosenAction(this.action, this.target);

  ActionParameters get parameters => action.parameters(target);

  ActionResult toResult() => parameters.toResult();

  void apply(ActionResult result) {
    parameters.apply(result);
  }
}

import "package:dungeons/game/combat_action.dart";
import "package:dungeons/game/combat_grid.dart";
import "package:dungeons/utility/value_callback.dart";
import "package:dungeons/widget/button.dart";
import "package:dungeons/widget/colors.dart";
import "package:dungeons/widget/spaced.dart";
import "package:flutter/widgets.dart";

typedef OnChosen = ValueCallback<CombatAction>;

class ActionSelect extends StatelessWidget {
  final GridMember actor;
  final OnChosen onChosen;

  const ActionSelect({
    super.key,
    required this.actor,
    required this.onChosen,
  });

  @override
  Widget build(BuildContext context) {
    return buildSpacedColumn(
      spacing: 12,
      children: [
        for (final action in _actions)
          if (action.visible) action.toButton(onChosen),
        for (final spell in actor.entity.knownSpells)
          _Action(spell.text, CastSpell(actor, spell)).toButton(onChosen),
      ],
    );
  }

  List<_Action> get _actions {
    return [
      _Action("Attack", UseWeapon(actor)),
      _Action("Two-Weapon Attack", UseTwoWeapons(actor)),
      _Action("Smite Attack", UseSmite(actor)),
      _Action("Rapid Shot", UseRapidShot(actor)),
      _Action("Defend", Defend(actor)),
    ];
  }
}

class _Action {
  final String name;
  final CombatAction action;

  const _Action(this.name, this.action);

  bool get visible => action.canUse;

  Button toButton(OnChosen onChosen) {
    return Button(
      text: name,
      enabled: action.hasResources,
      color: sourceColor(action.source),
      onClick: () => onChosen(action),
    );
  }
}

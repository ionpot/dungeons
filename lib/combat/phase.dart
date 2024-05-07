import "package:dungeons/combat/action_select.dart";
import "package:dungeons/combat/action_text.dart";
import "package:dungeons/combat/attribute_select.dart";
import "package:dungeons/combat/entity_portrait.dart";
import "package:dungeons/game/combat.dart";
import "package:dungeons/game/combat/action.dart";
import "package:dungeons/game/combat/action_input.dart";
import "package:dungeons/game/combat/grid.dart";
import "package:dungeons/game/combat/party.dart";
import "package:dungeons/game/entity.dart";
import "package:dungeons/game/entity/attributes.dart";
import "package:dungeons/game/text.dart";
import "package:dungeons/utility/value_callback.dart";
import "package:dungeons/widget/button.dart";
import "package:dungeons/widget/text_lines.dart";
import "package:dungeons/widget/titled_text_lines.dart";
import "package:flutter/widgets.dart";

class PortraitArgs {
  final bool? current;
  final PortraitTargeting? targeting;
  final VoidCallback? onClick;

  const PortraitArgs({this.current, this.targeting, this.onClick});
}

sealed class CombatPhase {
  const CombatPhase();

  Widget get buttons;
  Widget get display;

  PortraitArgs portraitArgs(GridMember member) => const PortraitArgs();
}

final class StartingPhase extends CombatPhase {
  final Entity first;
  final VoidCallback onNext;

  const StartingPhase({
    required this.first,
    required this.onNext,
  });

  @override
  Widget get buttons => Button(text: "Begin", onClick: onNext);

  @override
  Widget get display => Text("$first goes first.");
}

final class ActionSelectPhase extends CombatPhase {
  final GridMember actor;
  final ValueCallback<CombatAction> onChosen;

  const ActionSelectPhase({
    required this.actor,
    required this.onChosen,
  });

  @override
  Widget get buttons => ActionSelect(actor: actor, onChosen: onChosen);

  @override
  Widget get display => Text("What does $actor do?");
}

final class TargetingPhase extends CombatPhase {
  final Combat combat;
  final CombatAction action;
  final ValueCallback<GridMember> onChosen;
  final VoidCallback onCancel;

  const TargetingPhase(
    this.combat,
    this.action, {
    required this.onChosen,
    required this.onCancel,
  });

  @override
  Widget get buttons => Button(text: "Cancel", onClick: onCancel);

  @override
  Widget get display => const Text("Click on the target.");

  @override
  PortraitArgs portraitArgs(GridMember member) {
    return PortraitArgs(
      targeting: _targeting(member),
      onClick: () => onChosen(member),
    );
  }

  PortraitTargeting? _targeting(GridMember member) {
    if (action.canTarget(member, combat.grid)) {
      return combat.isAlly(member)
          ? PortraitTargeting.friendly
          : PortraitTargeting.enemy;
    }
    return PortraitTargeting.cantTarget;
  }
}

final class ActionResultPhase extends CombatPhase {
  final Combat combat;
  final ActionResult result;
  final VoidCallback onDone;

  const ActionResultPhase(
    this.combat,
    this.result, {
    required this.onDone,
  });

  @override
  Widget get buttons => Button(text: "Next", onClick: onDone);

  @override
  Widget get display {
    final text = ActionText(result);
    return TitledTextLines(
      title: combatTurnTitle(combat),
      lines: TextLines(text.lines),
    );
  }

  @override
  PortraitArgs portraitArgs(GridMember member) {
    return PortraitArgs(targeting: _targeting(member));
  }

  PortraitTargeting? _targeting(GridMember member) {
    if (result.input.target == member.entity) {
      return combat.isAlly(member)
          ? PortraitTargeting.friendly
          : PortraitTargeting.enemy;
    }
    return null;
  }
}

final class XpGainPhase extends CombatPhase {
  final Combat combat;
  final VoidCallback onDone;

  const XpGainPhase(this.combat, {required this.onDone});

  PartyXpGain get xpGain => combat.xpGain;

  @override
  Widget get buttons {
    return Button(
      text: xpGain.canLevelUp ? "Level Up" : "Next",
      onClick: onDone,
    );
  }

  @override
  Widget get display {
    return TitledTextLines(
      title: combatTurnTitle(combat),
      lines: TextLines([
        for (final PartyMember(:entity) in xpGain)
          Text(xpGainText(entity, xpGain.amount(entity))),
      ]),
    );
  }

  @override
  PortraitArgs portraitArgs(GridMember member) {
    return const PortraitArgs(current: false);
  }
}

final class LevelUpPhase extends CombatPhase {
  final Entity entity;
  final ValueCallback<EntityAttributeId> onAttribute;

  const LevelUpPhase(
    this.entity, {
    required this.onAttribute,
  });

  @override
  Widget get buttons => AttributeSelect(onChosen: onAttribute);

  @override
  Widget get display {
    return TitledTextLines.plain(
      title: "$entity leveled up",
      lines: ["Points remaining: ${entity.extraPoints}"],
    );
  }

  @override
  PortraitArgs portraitArgs(GridMember member) {
    return PortraitArgs(current: member.entity == entity);
  }
}

final class NoActionPhase extends CombatPhase {
  final Combat combat;
  final VoidCallback onNext;

  const NoActionPhase(this.combat, {required this.onNext});

  @override
  Widget get buttons => Button(text: "Next", onClick: onNext);

  @override
  Widget get display {
    return TitledTextLines.plain(
      title: combatTurnTitle(combat),
      lines: ["${combat.current} does nothing."],
    );
  }
}

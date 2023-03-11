import 'package:dungeons/game/combat.dart';
import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/smite.dart';
import 'package:dungeons/utility/value_callback.dart';
import 'package:dungeons/widget/button.dart';
import 'package:dungeons/widget/colors.dart';
import 'package:dungeons/widget/spaced.dart';
import 'package:flutter/widgets.dart';

class ActionSelect extends StatelessWidget {
  final Entity player;
  final Entity enemy;
  final ValueCallback<CombatAction> onChosen;

  const ActionSelect(
    this.player,
    this.enemy, {
    super.key,
    required this.onChosen,
  });

  @override
  Widget build(BuildContext context) {
    return buildSpacedColumn(
      spacing: 12,
      children: [
        Button(
          text: 'Attack',
          onClick: () => onChosen(CombatAction(target: enemy)),
        ),
        if (Smite.possible(player))
          Button(
            text: 'Smite Attack',
            color: sourceColor(Smite.source),
            enabled: Smite.hasStress(player),
            onClick: () {
              onChosen(CombatAction(target: enemy, smite: true));
            },
          ),
        for (final spell in player.knownSpells)
          Button(
            text: spell.text,
            enabled: player.canCast(spell),
            onClick: () {
              onChosen(CombatAction(
                castSpell: spell,
                target: spell.selfCast ? player : enemy,
              ));
            },
            color: sourceColor(spell.source),
          ),
      ],
    );
  }
}

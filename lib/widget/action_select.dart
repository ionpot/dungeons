import 'package:dungeons/game/combat.dart';
import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/spell.dart';
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
        Button('Attack', onClick: () => onChosen(CombatAction(target: enemy))),
        for (final spell in player.knownSpells)
          Button(
            spell.text,
            disabled: !player.canCast(spell),
            onClick: () => onChosen(
              CombatAction(
                castSpell: spell,
                target: spell == Spell.bless ? player : enemy,
              ),
            ),
            color: sourceColor(spell.source),
          ),
      ],
    );
  }
}

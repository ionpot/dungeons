import 'package:dungeons/game/combat.dart';
import 'package:dungeons/game/entity.dart';
import 'package:dungeons/utility/if.dart';
import 'package:dungeons/utility/value_callback.dart';
import 'package:dungeons/widget/button.dart';
import 'package:dungeons/widget/colors.dart';
import 'package:dungeons/widget/spaced.dart';
import 'package:flutter/widgets.dart';

class ActionSelect extends StatelessWidget {
  final Entity entity;
  final ValueCallback<CombatAction> onChosen;

  const ActionSelect(this.entity, {super.key, required this.onChosen});

  @override
  Widget build(BuildContext context) {
    return buildSpacedColumn(
      spacing: 12,
      children: [
        Button('Attack', onClick: () => onChosen(const CombatAction())),
        for (final spell in entity.knownSpells)
          Button(
            spell.text,
            disabled: !entity.canCast(spell),
            onClick: () => onChosen(CombatAction(castSpell: spell)),
            color: ifdef(spell.damage?.type, damageTypeColor),
          ),
      ],
    );
  }
}

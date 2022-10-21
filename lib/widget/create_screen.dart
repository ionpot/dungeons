import 'package:dungeons/game/armor.dart';
import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/entity_class.dart';
import 'package:dungeons/game/entity_race.dart';
import 'package:dungeons/game/weapon.dart';
import 'package:dungeons/widget/bold_text.dart';
import 'package:dungeons/widget/button.dart';
import 'package:dungeons/widget/colored.dart';
import 'package:dungeons/widget/label_value.dart';
import 'package:dungeons/widget/radio_group.dart';
import 'package:dungeons/widget/section.dart';
import 'package:flutter/widgets.dart';

class CreateScreen extends StatefulWidget {
  final ValueChanged<Entity> onDone;

  const CreateScreen({super.key, required this.onDone});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final Entity entity = Entity(
    'Player',
    player: true,
    race: EntityRace.human,
  );

  @override
  Widget build(BuildContext context) {
    final hasAttr = !entity.base.isEmpty();
    return Column(
      children: [
        const Section.below(child: Text('Create character')),
        Section.below(
          child: RadioGroup(
            values: EntityClass.values,
            onChange: (klass) {
              setState(() {
                entity.klass = klass;
                if (!hasAttr) entity.base.roll();
              });
            },
          ),
        ),
        if (entity.klass != null)
          Section.below(
            left: 100,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPrimary(),
                _buildSecondary(),
              ],
            ),
          ),
        if (hasAttr)
          Section.below(
            child: RadioGroup(
              values: Armor.values,
              onChange: (armor) {
                setState(() => entity.armor = armor);
              },
            ),
          ),
        if (hasAttr)
          Section.below(
            child: RadioGroup(
              values: Weapon.values,
              onChange: (weapon) {
                setState(() => entity.weapon = weapon);
              },
            ),
          ),
        if (entity.ok)
          Section.below(
            child: Button(
              text: 'Done',
              onClick: () => widget.onDone(entity),
            ),
          ),
      ],
    );
  }

  Widget _buildPrimary() {
    LabelValueMap content = {
      'Strength': BoldText(entity.strength.toString()),
      'Agility': BoldText(entity.agility.toString()),
      'Intellect': BoldText(entity.intellect.toString()),
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelValueTable(
          content: content,
          labelWidth: 64,
          valueWidth: 48,
        ),
        const SizedBox(height: 20),
        Button(
          text: 'Reroll',
          onClick: () => setState(entity.base.roll),
        ),
      ],
    );
  }

  Widget _buildSecondary() {
    return LabelValueTable(
      labelWidth: 86,
      valueWidth: 128,
      content: {
        'Total Hp': BoldText(entity.totalHp.toString()),
        'Stress Cap': BoldText(entity.stressCap.toString()),
        'Armor': BoldText(entity.totalArmor.toString()),
        'Initiative': ColoredInt(entity.initiative, bold: true),
        'Dodge': ColoredPercent(entity.dodge, bold: true),
        'Resist': BoldText(entity.resist.toString()),
        'Damage': BoldText(entity.damageDice?.fullText ?? ''),
      },
    );
  }
}

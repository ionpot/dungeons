import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/entity_armor.dart';
import 'package:dungeons/game/entity_attr.dart';
import 'package:dungeons/game/entity_class.dart';
import 'package:dungeons/game/entity_race.dart';
import 'package:dungeons/game/entity_weapon.dart';
import 'package:dungeons/widget/button.dart';
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
  final Entity entity = Entity('Player', race: human);

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
              values: EntityArmor.values,
              onChange: (armor) {
                setState(() => entity.armor = armor);
              },
            ),
          ),
        if (hasAttr)
          Section.below(
            child: RadioGroup(
              values: EntityWeapon.values,
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
    LabelValueMap content = {};
    for (final id in EntityAttributeId.values) {
      content[id.text] = entity.attributes.ofId(id).toString();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelValueTable(
          content: content,
          labelWidth: 64,
          valueWidth: 48,
        ),
        Button(
          text: 'Reroll',
          onClick: () => setState(entity.base.roll),
        ),
      ],
    );
  }

  Widget _buildSecondary() {
    return LabelValueTable(
      labelWidth: 64,
      valueWidth: 128,
      content: {
        'Total Hp': entity.totalHp().toString(),
        'Armor': entity.totalArmor().toString(),
        'Initiative': entity.initiative.toString(),
        'Dodge': entity.dodge.text,
        'Resist': entity.resist.text,
        'Damage': entity.damageDice?.fullText ?? '',
      },
    );
  }
}

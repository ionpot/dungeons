import 'package:dungeons/game/armor.dart';
import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/entity_class.dart';
import 'package:dungeons/game/entity_race.dart';
import 'package:dungeons/game/weapon.dart';
import 'package:dungeons/widget/bold_text.dart';
import 'package:dungeons/widget/button.dart';
import 'package:dungeons/widget/colored_text.dart';
import 'package:dungeons/widget/label_value.dart';
import 'package:dungeons/widget/radio_group.dart';
import 'package:dungeons/widget/spaced.dart';
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
    return Container(
      padding: const EdgeInsets.all(30),
      child: buildSpacedColumn(
        children: [
          const Text('New character'),
          _classSelect,
          if (_hasClass) _attrAndStats,
          if (_hasAttr) _armorSelect,
          if (_hasAttr) _weaponSelect,
          if (entity.ok)
            Button(text: 'Done', onClick: () => widget.onDone(entity)),
        ],
      ),
    );
  }

  Widget get _classSelect {
    return RadioGroup(
      values: EntityClass.values,
      onChange: (klass) {
        setState(() {
          entity.klass = klass;
          if (!_hasAttr) entity.base.roll();
        });
      },
    );
  }

  Widget get _attrAndStats {
    return buildSpacedRow(
      children: [_attrRoll, _stats],
      spacing: 0,
    );
  }

  Widget get _attrRoll {
    return buildSpacedColumn(
      spacing: 20,
      children: [
        LabelValueTable(
          labelWidth: 72,
          valueWidth: 48,
          content: {
            'Strength': BoldText('${entity.strength}'),
            'Agility': BoldText('${entity.agility}'),
            'Intellect': BoldText('${entity.intellect}'),
          },
        ),
        Button(
          text: 'Reroll',
          onClick: () => setState(entity.base.roll),
        ),
      ],
    );
  }

  Widget get _stats {
    return LabelValueTable(
      labelWidth: 86,
      valueWidth: 128,
      content: {
        'Total Hp': BoldText(entity.totalHp.toString()),
        'Stress Cap': BoldText(entity.stress.cap.toString()),
        'Armor': BoldText(entity.totalArmor.toString()),
        'Initiative': coloredIntText(entity.initiative, bold: true),
        'Dodge': coloredPercentText(entity.dodge, bold: true),
        'Resist': BoldText(entity.resist.toString()),
        'Damage': BoldText(entity.damageDice?.fullText ?? ''),
      },
    );
  }

  Widget get _armorSelect {
    return RadioGroup(
      values: Armor.values,
      onChange: (armor) {
        setState(() => entity.armor = armor);
      },
    );
  }

  Widget get _weaponSelect {
    return RadioGroup(
      values: Weapon.values,
      onChange: (weapon) {
        setState(() => entity.weapon = weapon);
      },
    );
  }

  bool get _hasAttr => !entity.base.isEmpty();
  bool get _hasClass => entity.klass != null;
}

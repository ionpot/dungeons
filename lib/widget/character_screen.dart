import 'package:dungeons/game/armor.dart';
import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/entity_attr.dart';
import 'package:dungeons/game/entity_class.dart';
import 'package:dungeons/game/entity_race.dart';
import 'package:dungeons/game/weapon.dart';
import 'package:dungeons/widget/bold_text.dart';
import 'package:dungeons/widget/button.dart';
import 'package:dungeons/widget/empty.dart';
import 'package:dungeons/widget/label_value.dart';
import 'package:dungeons/widget/radio_group.dart';
import 'package:dungeons/widget/spaced.dart';
import 'package:dungeons/widget/value_span.dart';
import 'package:flutter/widgets.dart';

class CharacterScreen extends StatefulWidget {
  final ValueChanged<Entity> onDone;

  const CharacterScreen({super.key, required this.onDone});

  @override
  State<CharacterScreen> createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen> {
  EntityAttributes? _attributes;
  EntityClass? _class;
  Weapon? _weapon;
  Armor? _armor;

  Entity? get _entity {
    if (_attributes == null || _class == null) return null;
    return Entity(
      name: 'Player',
      player: true,
      klass: _class!,
      race: EntityRace.human,
    )
      ..base = _attributes!
      ..weapon = _weapon
      ..armor = _armor;
  }

  @override
  Widget build(BuildContext context) {
    final entity = _entity;
    return Container(
      padding: const EdgeInsets.all(30),
      child: buildSpacedColumn(
        children: [
          const Text('New character'),
          _classSelect(),
          if (entity != null) _attrAndStats(entity),
          if (entity != null) _armorSelect(),
          if (entity != null) _weaponSelect(),
          if (entity != null && _weapon != null && _armor != null)
            Button('Done', onClick: () => widget.onDone(entity)),
        ],
      ),
    );
  }

  Widget _classSelect() {
    return RadioGroup(
      values: EntityClass.values,
      onChange: (klass) {
        setState(() {
          _class = klass;
          _attributes ??= EntityAttributes.random();
        });
      },
    );
  }

  Widget _attrAndStats(Entity entity) {
    return buildSpacedRow(
      children: [_attrRoll(entity), _stats(entity)],
      spacing: 0,
    );
  }

  Widget _attrRoll(Entity entity) {
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
        Button('Reroll', onClick: () {
          setState(() => _attributes?.roll());
        }),
      ],
    );
  }

  Widget _stats(Entity entity) {
    final damage = entity.weaponDamage;
    return LabelValueTable(
      labelWidth: 86,
      valueWidth: 128,
      content: {
        'Total Hp': BoldText('${entity.totalHp}'),
        'Stress Cap': BoldText('${entity.stressCap}'),
        'Armor': BoldText('${entity.totalArmor}'),
        'Initiative': BoldText.fromSpan(IntValueSpan(entity.initiative)),
        'Dodge': BoldText.fromSpan(PercentValueSpan(entity.dodge)),
        'Resist': BoldText('${entity.resist}'),
        'Damage': damage != null
            ? BoldText('($damage) ${damage.range}')
            : const Empty(),
      },
    );
  }

  Widget _armorSelect() {
    return RadioGroup(
      values: Armor.values,
      onChange: (armor) {
        setState(() => _armor = armor);
      },
    );
  }

  Widget _weaponSelect() {
    return RadioGroup(
      values: Weapon.values,
      onChange: (weapon) {
        setState(() => _weapon = weapon);
      },
    );
  }
}

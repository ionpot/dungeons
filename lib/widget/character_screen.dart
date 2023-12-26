import "package:dungeons/game/armor.dart";
import "package:dungeons/game/entity.dart";
import "package:dungeons/game/entity_class.dart";
import "package:dungeons/game/entity_race.dart";
import "package:dungeons/game/gear.dart";
import "package:dungeons/game/weapon.dart";
import "package:dungeons/widget/button.dart";
import "package:dungeons/widget/dice_span.dart";
import "package:dungeons/widget/empty.dart";
import "package:dungeons/widget/entity_span.dart";
import "package:dungeons/widget/label_value.dart";
import "package:dungeons/widget/radio_button.dart";
import "package:dungeons/widget/radio_group.dart";
import "package:dungeons/widget/spaced.dart";
import "package:dungeons/widget/text.dart";
import "package:dungeons/widget/value_span.dart";
import "package:flutter/widgets.dart";

class CharacterScreen extends StatefulWidget {
  final ValueChanged<Entity> onDone;

  const CharacterScreen({super.key, required this.onDone});

  @override
  State<CharacterScreen> createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen> {
  late Entity _entity;

  @override
  void initState() {
    super.initState();
    _entity = Entity(
      name: "Player",
      race: EntityRace.human,
    )..base.roll();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      child: buildSpacedColumn(
        children: [
          const Text("New character"),
          _classSelect,
          if (_entity.klass != null) _attrAndStats,
          if (_entity.klass != null) _armorSelect,
          if (_entity.klass != null) _weaponSelect,
          if (_entity.klass != null) _offHandSelect,
          if (_entity.klass != null &&
              _entity.weapon != null &&
              _entity.armor != null)
            Button(text: "Done", onClick: () => widget.onDone(_entity)),
        ],
      ),
    );
  }

  Widget get _classSelect {
    return RadioGroup([
      for (final klass in EntityClass.values)
        RadioButton(
          text: "$klass",
          chosen: klass == _entity.klass,
          onChosen: () {
            setState(() {
              _entity.klass = klass;
            });
          },
        ),
    ]);
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
            "Strength": BoldText("${_entity.strength}"),
            "Agility": BoldText("${_entity.agility}"),
            "Intellect": BoldText("${_entity.intellect}"),
          },
        ),
        Button(
          text: "Reroll",
          onClick: () {
            setState(_entity.base.roll);
          },
        ),
      ],
    );
  }

  Widget get _stats {
    final damage = _entity.weaponDamage;
    return LabelValueTable(
      labelWidth: 86,
      valueWidth: 128,
      content: {
        "Total Hp": Text.rich(ValueSpan(_entity.totalHp, style: bold)),
        "Stress Cap": Text.rich(ValueSpan(_entity.stressCap, style: bold)),
        "Armor": Text.rich(TotalArmorSpan(_entity, style: bold)),
        "Initiative": Text.rich(ValueSpan(_entity.initiative, style: bold)),
        "Dodge": Text.rich(ValueSpan(_entity.dodge, style: bold)),
        "Resist": Text.rich(ValueSpan(_entity.resist, style: bold)),
        "Damage": damage != null
            ? Text.rich(DiceValueWithRangeSpan(damage, style: bold))
            : const Empty(),
      },
    );
  }

  Widget get _armorSelect {
    return RadioGroup([
      for (final armor in Armor.values)
        RadioButton(
          text: "$armor",
          chosen: armor == _entity.gear.body,
          onChosen: () {
            setState(() {
              _entity.equip(Gear(body: armor));
            });
          },
        ),
    ]);
  }

  Widget get _weaponSelect {
    return RadioGroup([
      for (final weapon in Weapon.forMainHand)
        RadioButton(
          text: "$weapon",
          chosen: weapon == _entity.gear.mainHand,
          enabled: _entity.canEquip(Gear(mainHand: weapon)),
          onChosen: () {
            setState(() {
              _entity.equip(Gear(mainHand: weapon));
            });
          },
        ),
    ]);
  }

  Widget get _offHandSelect {
    return RadioGroup([
      for (final weapon in Weapon.forOffHand)
        RadioButton(
          text: "$weapon",
          chosen: weapon == _entity.gear.offHand,
          enabled: _entity.canEquip(Gear(offHand: weapon)),
          onChosen: () {
            setState(() {
              _entity.equip(Gear(offHand: weapon));
            });
          },
        ),
      RadioButton(
        text: "None",
        chosen: _entity.gear.offHand == null,
        onChosen: () {
          setState(() {
            _entity.gear.offHand = null;
          });
        },
      ),
    ]);
  }
}

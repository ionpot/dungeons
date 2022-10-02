import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/entity_armor.dart';
import 'package:dungeons/game/entity_class.dart';
import 'package:dungeons/game/entity_race.dart';
import 'package:dungeons/widget/button.dart';
import 'package:dungeons/widget/entity_info.dart';
import 'package:dungeons/widget/radio_group.dart';
import 'package:dungeons/widget/section.dart';
import 'package:flutter/widgets.dart';

class CreateScreen extends StatefulWidget {
  final VoidCallback onDone;

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
              setState(() => entity.klass = klass);
            },
          ),
        ),
        if (entity.klass != null)
          Section.below(
            child: Button(
              text: 'Roll attributes',
              onClick: () => setState(entity.base.roll),
            ),
          ),
        if (hasAttr) Section.below(child: EntityInfo(entity)),
        if (hasAttr)
          Section.below(
            child: RadioGroup(
              values: EntityArmor.values,
              onChange: (armor) {
                setState(() => entity.armor = armor);
              },
            ),
          ),
        Section.below(
          child: Button(
            text: 'Done',
            onClick: widget.onDone,
          ),
        ),
      ],
    );
  }
}
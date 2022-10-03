import 'package:dungeons/utility/has_text.dart';
import 'package:dungeons/utility/scale.dart';

enum EntityArmor implements HasText {
  leather(text: 'Leather', value: 15, dodge: Scale(1.5)),
  scalemail(text: 'Scale Mail', value: 25, initiative: -5);

  const EntityArmor({
    required this.text,
    required this.value,
    this.initiative = 0,
    this.dodge = const Scale(),
  });

  final int value;
  final int initiative;
  final Scale dodge;

  @override
  final String text;
}

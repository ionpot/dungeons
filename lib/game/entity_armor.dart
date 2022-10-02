import 'package:dungeons/utility/has_text.dart';

enum EntityArmor implements HasText {
  leather(text: 'Leather', value: 15, initiative: 0),
  scalemail(text: 'Scale Mail', value: 25, initiative: -5);

  const EntityArmor({
    required this.text,
    required this.value,
    required this.initiative,
  });

  final int value;
  final int initiative;

  @override
  final String text;
}

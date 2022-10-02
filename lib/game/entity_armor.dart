import 'package:dungeons/utility/has_text.dart';

enum EntityArmor implements HasText {
  leather(text: 'Leather', value: 15),
  scalemail(text: 'Scale Mail', value: 25);

  const EntityArmor({required this.text, required this.value});

  final int value;

  @override
  final String text;
}

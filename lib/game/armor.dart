import 'package:dungeons/utility/pick_random.dart';
import 'package:dungeons/utility/scale.dart';

enum Armor {
  leather(text: 'Leather', value: 15, dodge: Scale(1.5)),
  scalemail(text: 'Scale Mail', value: 25, initiative: -5);

  final int value;
  final int initiative;
  final Scale dodge;
  final String text;

  const Armor({
    required this.text,
    required this.value,
    this.initiative = 0,
    this.dodge = const Scale(),
  });

  factory Armor.random() => pickRandom(Armor.values);

  @override
  String toString() => text;
}

import 'package:dungeons/game/effect.dart';
import 'package:dungeons/utility/percent.dart';
import 'package:dungeons/utility/pick_random.dart';

enum Armor {
  leather(text: 'Leather', value: 15, dodge: Percent(50)),
  scalemail(text: 'Scale Mail', value: 25, initiative: -5);

  final int value;
  final int? initiative;
  final Percent? dodge;
  final String text;

  const Armor({
    required this.text,
    required this.value,
    this.initiative,
    this.dodge,
  });

  factory Armor.random() => pickRandom(Armor.values);

  Effect get effect {
    return Effect(
      dodgeScale: dodge,
      initiative: initiative,
    );
  }

  @override
  String toString() => text;
}

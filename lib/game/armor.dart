import 'package:dungeons/game/effect.dart';
import 'package:dungeons/utility/multiplier.dart';
import 'package:dungeons/utility/pick_random.dart';

enum Armor {
  leather(text: 'Leather', value: 15, dodge: Multiplier(0.5)),
  scalemail(text: 'Scale Mail', value: 25, initiative: -5);

  final int value;
  final int? initiative;
  final Multiplier? dodge;
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
      dodgeMultiplier: dodge,
      initiative: initiative,
    );
  }

  @override
  String toString() => text;
}

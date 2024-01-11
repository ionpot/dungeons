import "package:dungeons/game/entity/bonus_value.dart";
import "package:dungeons/utility/monoids.dart";
import "package:dungeons/utility/random.dart";

enum Armor {
  leather(text: "Leather", value: 10, dodge: Multiplier(0.5)),
  scalemail(text: "Scale Mail", value: 20, initiative: -5);

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

  BonusValue? get bonus {
    if (dodge != null) {
      return MultiplierBonus.dodge(dodge!);
    }
    if (initiative != null) {
      return IntBonus.initiative(initiative!);
    }
    return null;
  }

  @override
  String toString() => text;
}

import "package:dungeons/game/bonus.dart";
import "package:dungeons/game/bonus_map.dart";
import "package:dungeons/utility/dice.dart";
import "package:dungeons/utility/range.dart";

class DiceBonuses extends BonusMap<Dice> {
  const DiceBonuses(super.contents);

  DiceBonuses.empty(): super({});

  int get maxTotal => Dice.maxTotal(contents.values);
  Range get range => Dice.totalRange(contents.values);

  Map<Bonus, Dice> findWithSides(int sides) {
    return Map.of(contents)..removeWhere((key, value) => value.sides != sides);
  }

  Map<Bonus, DiceRoll> roll() {
    return contents.mapValues((dice) => dice.roll());
  }

  Map<Bonus, DiceRoll> rollMax() {
    return contents.mapValues((dice) => dice.rollMax());
  }

  @override
  String toString() => contents.values.fold("", (str, dice) => "$str+$dice");
}

import "package:dungeons/game/entity/value.dart";
import "package:dungeons/utility/dice.dart";
import "package:dungeons/utility/monoids.dart";

class ChanceRoll {
  final DiceRoll rolls;

  ChanceRoll([int count = 1]) : rolls = Dice(count, 100).roll();

  bool meets(Percent percent) {
    if (percent.always) return true;
    if (percent.never) return false;
    return rolls.any(percent.success);
  }

  bool allMeet(Percent percent) {
    if (percent.always) return true;
    if (percent.never) return false;
    return rolls.every(percent.success);
  }

  bool fails(Percent percent) => !meets(percent);

  bool meetsV(Value<Percent> percent) => meets(percent.total);
  bool failsV(Value<Percent> percent) => fails(percent.total);

  bool allMeetV(Value<Percent> percent) => allMeet(percent.total);

  @override
  String toString() => rolls.toString();
}

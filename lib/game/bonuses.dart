import "package:dungeons/game/bonus.dart";
import "package:dungeons/game/bonus_map.dart";
import "package:dungeons/utility/dice.dart";
import "package:dungeons/utility/monoids.dart";

class Bonuses<T extends Monoid> extends BonusMap<T> {
  const Bonuses(super.contents);

  Bonuses.copy(Bonuses<T> input) : this(Map.of(input.contents));
  Bonuses.empty() : this({});

  static Bonuses<Int> totals(Map<Bonus, DiceRoll> map) {
    return Bonuses(map.mapValues((value) => Int(value.total)));
  }

  T get total => contents.values.total;

  @override
  void add(Bonus bonus, T value) {
    contents.update(
      bonus,
      (existing) => existing + value as T,
      ifAbsent: () => value,
    );
  }

  Bonuses<T> operator +(Bonuses<T> other) {
    final copy = Bonuses.copy(this);
    for (final entry in other) {
      copy.add(entry.bonus, entry.value);
    }
    return copy;
  }
}

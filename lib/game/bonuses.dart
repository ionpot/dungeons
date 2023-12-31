import "package:dungeons/game/bonus.dart";
import "package:dungeons/game/bonus_entry.dart";
import "package:dungeons/game/bonus_map.dart";
import "package:dungeons/utility/dice.dart";
import "package:dungeons/utility/monoids.dart";

class Bonuses<T extends Monoid> extends Iterable<BonusEntry<T>> {
  final List<BonusEntry<T>> contents;

  const Bonuses(this.contents);

  Bonuses.empty() : this([]);

  Bonuses.fromMap(Map<Bonus, T> map)
      : this([
          for (final MapEntry(:key, :value) in map.entries)
            BonusEntry(key, value),
        ]);

  static Bonuses<Int> totals(Map<Bonus, DiceRoll> map) {
    return Bonuses.fromMap(map.mapValues((value) => Int(value.total)));
  }

  List<BonusEntry<List<T>>> get grouped {
    return contents.clean.group.toList();
  }

  T get total => contents.total;

  void add(Bonus bonus, T value) {
    contents.add(BonusEntry(bonus, value));
  }

  Bonuses<T> operator +(Bonuses<T> other) {
    return Bonuses(contents + other.contents);
  }

  @override
  Iterator<BonusEntry<T>> get iterator => contents.iterator;
}

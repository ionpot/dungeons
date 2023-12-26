import "package:dungeons/game/bonus.dart";
import "package:dungeons/game/bonus_entry.dart";
import "package:dungeons/game/bonus_value.dart";
import "package:dungeons/game/bonuses.dart";
import "package:dungeons/utility/monoids.dart";

typedef BonusValueEntry = BonusEntry<BonusValue>;

class BonusPool {
  final List<BonusValueEntry> _contents;

  const BonusPool(this._contents);

  BonusPool.empty() : this([]);

  BonusPool operator +(BonusPool other) {
    return BonusPool(List.of(_contents)..addAll(other._contents));
  }

  bool has(Bonus bonus) {
    return _contents.any((entry) => entry.bonus == bonus);
  }

  void add(Bonus bonus, BonusValue value) {
    _contents.add(BonusValueEntry(bonus, value));
  }

  void addValues(Bonus bonus, List<BonusValue> values) {
    for (final value in values) {
      add(bonus, value);
    }
  }

  void clear() {
    _contents.clear();
  }

  Bonuses<Int> ints(IntBonusTo type) {
    return Bonuses(_find<IntBonusTo, Int>(type));
  }

  Bonuses<Percent> percents(PercentBonusTo type) {
    return Bonuses(_find<PercentBonusTo, Percent>(type));
  }

  Bonuses<Multiplier> multipliers(MultiplierBonusTo type) {
    return Bonuses(_find<MultiplierBonusTo, Multiplier>(type));
  }

  Map<Bonus, V> _find<T extends Object, V extends Monoid>(T target) {
    return {
      for (final entry in _contents)
        if (entry.value is V && entry.value.target == target)
          entry.bonus: entry.value.value as V,
    };
  }
}

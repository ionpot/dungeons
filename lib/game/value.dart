import "package:dungeons/game/bonus_entry.dart";
import "package:dungeons/game/bonuses.dart";
import "package:dungeons/utility/monoids.dart";

class Value<T extends Monoid> implements Comparable<Value<T>> {
  final T base;
  final Bonuses<T> bonuses;
  final Bonuses<Multiplier> multipliers;
  final List<BonusEntry<T>> reserved;

  const Value(
    this.base,
    this.bonuses, {
    required this.multipliers,
    required this.reserved,
  });

  Value.from(
    this.base,
    this.bonuses, {
    Bonuses<Multiplier>? multipliers,
    List<BonusEntry<T>>? reserved,
  })  : multipliers = multipliers ?? Bonuses.empty(),
        reserved = reserved ?? [];

  Value.fromBase(T base) : this.from(base, Bonuses.empty());

  T get multiplierBonus => multiply(multipliers.total);
  T get bonus => bonuses.total + multiplierBonus as T;
  T get cap => base + bonus as T;
  T get total => cap - reserved.total as T;

  T multiply(Multiplier m) {
    return (base + bonuses.total).multiply(m) as T;
  }

  bool operator >(Value<T> other) {
    return compareTo(other) == 1;
  }

  List<BonusEntry<T>> get bonusList {
    return [
      for (final entry in bonuses) entry,
      for (final entry in multipliers)
        BonusEntry(entry.bonus, multiply(entry.value)),
    ];
  }

  @override
  compareTo(Value<T> other) {
    return total.compareTo(other.total);
  }

  @override
  String toString() => "$total";
}

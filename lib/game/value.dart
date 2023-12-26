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

  Value.from(this.base, [Bonuses<T>? map])
      : bonuses = map ?? Bonuses.empty(),
        multipliers = Bonuses.empty(),
        reserved = [];

  Value.copy(Value<T> value)
      : this(
          value.base,
          Bonuses.copy(value.bonuses),
          multipliers: Bonuses.copy(value.multipliers),
          reserved: List.of(value.reserved),
        );

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
    return compareTo(other);
  }

  @override
  String toString() => "$total";
}

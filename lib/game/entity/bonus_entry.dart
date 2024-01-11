import "package:dungeons/game/entity/bonus.dart";
import "package:dungeons/utility/monoids.dart";

class BonusEntry<T extends Object> {
  final Bonus bonus;
  final T value;

  const BonusEntry(this.bonus, this.value);

  BonusEntry.fromMapEntry(MapEntry<Bonus, T> entry)
      : this(entry.key, entry.value);
}

class BonusEntryIterator<T extends Object> implements Iterator<BonusEntry<T>> {
  final Iterator<MapEntry<Bonus, T>> _iterator;

  const BonusEntryIterator(this._iterator);

  @override
  BonusEntry<T> get current => BonusEntry.fromMapEntry(_iterator.current);

  @override
  bool moveNext() => _iterator.moveNext();
}

extension BonusEntryIterable<T extends Monoid> on Iterable<BonusEntry<T>> {
  T get total => map((e) => e.value).total;
}

extension BonusEntryList<T extends Monoid> on List<BonusEntry<T>> {
  List<BonusEntry<T>> get clean {
    return [
      for (final entry in this)
        if (entry.value.hasValue) entry,
    ];
  }

  Map<Bonus, List<T>> get group {
    final map = <Bonus, List<T>>{};
    for (final entry in this) {
      final ls = map.putIfAbsent(entry.bonus, () => []);
      ls.add(entry.value);
    }
    return map;
  }

  void removeWhereBonus(bool Function(Bonus) fn) {
    removeWhere((entry) => fn(entry.bonus));
  }
}

extension BonusEntryMap<T extends Object> on Map<Bonus, T> {
  List<BonusEntry<T>> toList() {
    return [
      for (final entry in entries) BonusEntry.fromMapEntry(entry),
    ];
  }
}

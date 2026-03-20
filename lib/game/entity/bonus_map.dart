import "package:dungeons/game/entity/bonus.dart";
import "package:dungeons/game/entity/bonus_entry.dart";

class BonusMap<T extends Object> extends Iterable<BonusEntry<T>> {
  final Map<Bonus, T> contents;

  const BonusMap(this.contents);

  @override
  Iterator<BonusEntry<T>> get iterator {
    return BonusEntryIterator<T>(contents.entries.iterator);
  }
}

extension MapX<T extends Object> on Map<Bonus, T> {
  Map<Bonus, V> mapValues<V extends Object>(V Function(T) f) {
    return map((key, value) => MapEntry(key, f(value)));
  }
}

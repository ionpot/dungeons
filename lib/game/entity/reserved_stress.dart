import "package:dungeons/game/entity.dart";
import "package:dungeons/game/entity/bonus_entry.dart";
import "package:dungeons/utility/monoids.dart";

class ReservedStress {
  final List<_Entry> _contents;

  const ReservedStress(this._contents);
  ReservedStress.empty() : this([]);

  List<BonusEntry<Int>> get list {
    return [
      for (final item in _contents)
        if (item.active) item.entry,
    ];
  }

  void add(BonusEntry<Int> entry, Entity target) {
    _contents.add(_Entry(entry, target));
  }

  void clear() => _contents.clear();
}

class _Entry {
  final BonusEntry<Int> entry;
  final Entity target;

  const _Entry(this.entry, this.target);

  bool get active => target.alive;
}

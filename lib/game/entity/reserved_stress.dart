import "package:dungeons/game/entity/bonus.dart";
import "package:dungeons/game/entity/bonus_entry.dart";
import "package:dungeons/utility/monoids.dart";

class ReservedStress {
  final List<BonusEntry<Int>> _contents;

  const ReservedStress(this._contents);
  ReservedStress.empty() : this([]);

  Iterable<BonusEntry<Int>> get list => _contents;

  void add(BonusEntry<Int> entry) {
    _contents.add(entry);
  }

  void remove(Bonus source) {
    _contents.removeWhere((entry) => entry.bonus == source);
  }

  void clear() => _contents.clear();
}

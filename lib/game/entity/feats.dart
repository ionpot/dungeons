import "package:dungeons/game/entity/bonus.dart";
import "package:dungeons/game/entity/bonus_entry.dart";
import "package:dungeons/game/entity/bonus_pool.dart";
import "package:dungeons/game/entity/feat.dart";
import "package:dungeons/utility/if.dart";
import "package:dungeons/utility/monoids.dart";

typedef FeatMap = Map<Feat, FeatTier>;

class EntityFeats extends Iterable<FeatSlot> {
  final FeatMap contents;

  const EntityFeats(this.contents);

  BonusPool get bonuses {
    final pool = BonusPool.empty();
    for (final slot in this) {
      pool.addValues(FeatBonus(slot), slot.value.bonuses);
    }
    return pool;
  }

  List<BonusEntry<Int>> get reserveStress {
    return [
      for (final slot in this)
        if (slot.value.reserveStress != null)
          BonusEntry(FeatBonus(slot), Int(slot.value.reserveStress!)),
    ];
  }

  bool has(Feat feat) => contents.containsKey(feat);

  FeatSlot? find(Feat feat) {
    return ifdef(contents[feat], (tier) => FeatSlot(feat, tier));
  }

  @override
  Iterator<FeatSlot> get iterator =>
      EntityFeatsIterator(contents.entries.iterator);
}

class EntityFeatsIterator implements Iterator<FeatSlot> {
  final Iterator<MapEntry<Feat, FeatTier>> iterator;

  EntityFeatsIterator(this.iterator);

  @override
  FeatSlot get current {
    final entry = iterator.current;
    return FeatSlot(entry.key, entry.value);
  }

  @override
  bool moveNext() => iterator.moveNext();
}

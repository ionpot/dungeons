import 'package:dungeons/game/bonus.dart';
import 'package:dungeons/game/bonuses.dart';
import 'package:dungeons/game/feat.dart';
import 'package:dungeons/utility/if.dart';

typedef FeatMap = Map<Feat, FeatTier>;

class EntityFeats extends Iterable<FeatSlot> {
  final FeatMap contents;

  const EntityFeats(this.contents);

  Bonuses get bonuses {
    return Bonuses({
      for (final slot in this)
        if (slot.value.effect != null) FeatBonus(slot): slot.value.effect!,
    });
  }

  IntBonuses get reserveStress {
    return IntBonuses({
      for (final slot in this)
        if (slot.value.reserveStress != null)
          FeatBonus(slot): slot.value.reserveStress!,
    });
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

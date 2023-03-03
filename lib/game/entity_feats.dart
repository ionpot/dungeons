import 'package:dungeons/game/bonus.dart';
import 'package:dungeons/game/bonuses.dart';
import 'package:dungeons/game/feat.dart';
import 'package:dungeons/utility/if.dart';

typedef FeatMap = Map<Feat, FeatTier>;

class EntityFeats {
  final FeatMap map;

  const EntityFeats(this.map);

  Bonuses get bonuses {
    final bonuses = Bonuses();
    for (final entry in map.entries) {
      bonuses.add(Bonus(feat: FeatSlot(entry.key, entry.value)));
    }
    return bonuses;
  }

  bool has(Feat feat) => map.containsKey(feat);

  FeatSlot? find(Feat feat) {
    return ifdef(map[feat], (tier) => FeatSlot(feat, tier));
  }
}

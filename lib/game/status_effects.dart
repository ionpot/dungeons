import "package:dungeons/game/bonus.dart";
import "package:dungeons/game/bonus_entry.dart";
import "package:dungeons/game/bonus_map.dart";
import "package:dungeons/game/bonus_pool.dart";
import "package:dungeons/game/status_effect.dart";

class StatusEffects extends BonusMap<StatusEffect> {
  const StatusEffects(super.contents);

  StatusEffects.empty(): super({});

  Bonus? findBonusOf(StatusEffect effect) {
    for (final entry in this) {
      if (entry.value == effect || entry.value.effects.contains(effect)) {
        return entry.bonus;
      }
    }
    return null;
  }

  BonusPool get bonuses {
    return BonusPool([
      for (final entry in this)
        for (final value in entry.value.bonuses)
          BonusEntry(entry.bonus, value),
    ]);
  }
}

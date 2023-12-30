import "package:dungeons/game/bonus.dart";
import "package:dungeons/game/bonus_entry.dart";
import "package:dungeons/game/bonus_pool.dart";
import "package:dungeons/game/status_effect.dart";

class StatusEffects extends Iterable<BonusEntry<StatusEffect>> {
  final List<BonusEntry<StatusEffect>> contents;

  const StatusEffects(this.contents);

  StatusEffects.empty() : this([]);

  bool has(StatusEffect effect) {
    return findBonusOf(effect) != null;
  }

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
        for (final value in entry.value.bonuses) BonusEntry(entry.bonus, value),
    ]);
  }

  StatusEffects operator +(StatusEffects other) {
    return StatusEffects(contents + other.contents);
  }

  void addAll(StatusEffects other) {
    contents.addAll(other.contents);
  }

  void clear() => contents.clear();

  @override
  Iterator<BonusEntry<StatusEffect>> get iterator => contents.iterator;
}

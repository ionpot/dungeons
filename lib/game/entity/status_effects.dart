import "package:dungeons/game/entity/bonus.dart";
import "package:dungeons/game/entity/bonus_entry.dart";
import "package:dungeons/game/entity/bonus_pool.dart";
import "package:dungeons/game/entity/status_effect.dart";

class StatusEffects extends Iterable<BonusEntry<StatusEffect>> {
  final List<BonusEntry<StatusEffect>> contents;

  const StatusEffects(this.contents);

  StatusEffects.empty() : this([]);
  StatusEffects.single(Bonus bonus, StatusEffect effect)
      : this([BonusEntry(bonus, effect)]);

  bool has(StatusEffect effect) {
    return findBonusOf(effect) != null;
  }

  bool hasBonus(Bonus bonus) {
    return any((entry) => entry.bonus == bonus);
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
      for (final BonusEntry(:bonus, :value) in this)
        for (final bonusValue in value.bonuses)
          BonusEntry(EffectBonus(bonus, value), bonusValue),
    ]);
  }

  StatusEffects operator +(StatusEffects other) {
    return StatusEffects(contents + other.contents);
  }

  void add(Bonus bonus, StatusEffect effect) {
    contents.add(BonusEntry(bonus, effect));
  }

  void addAll(StatusEffects other) {
    contents.addAll(other.contents);
  }

  void clear() => contents.clear();

  void removeBonus(Bonus bonus) {
    contents.removeWhere((entry) => entry.bonus == bonus);
  }

  @override
  Iterator<BonusEntry<StatusEffect>> get iterator => contents.iterator;
}

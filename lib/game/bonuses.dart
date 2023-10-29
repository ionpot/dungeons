import 'dart:math';

import 'package:dungeons/game/bonus.dart';
import 'package:dungeons/game/effect.dart';
import 'package:dungeons/utility/bonus_text.dart';
import 'package:dungeons/utility/dice.dart';
import 'package:dungeons/utility/multiplier.dart';
import 'package:dungeons/utility/percent.dart';
import 'package:dungeons/utility/range.dart';

typedef EffectMap = BonusMap<Effect>;

class BonusEntry<T extends Object> {
  final Bonus bonus;
  final T value;

  const BonusEntry(this.bonus, this.value);

  factory BonusEntry.fromMapEntry(MapEntry<Bonus, T> entry) {
    return BonusEntry(entry.key, entry.value);
  }
}

class BonusEntryIterator<T extends Object> implements Iterator<BonusEntry<T>> {
  final Iterator<MapEntry<Bonus, T>> iterator;

  const BonusEntryIterator(this.iterator);

  @override
  BonusEntry<T> get current => BonusEntry.fromMapEntry(iterator.current);

  @override
  bool moveNext() => iterator.moveNext();
}

typedef GetValue<T extends Object> = T? Function(Effect);

class Bonuses extends Iterable<BonusEntry<Effect>> {
  final EffectMap contents;

  Bonuses([EffectMap? m]) : contents = m ?? {};

  bool has(Bonus bonus) => contents.containsKey(bonus);

  void add(Bonus bonus, Effect? effect) {
    if (effect != null) {
      addEntry(bonus, effect);
    }
  }

  void addEntry(Bonus bonus, Effect effect) {
    contents.update(
      bonus,
      (value) => bonus.stacks ? value + effect : effect,
      ifAbsent: () => effect,
    );
  }

  void addAll(Bonuses other) {
    for (final entry in other) {
      addEntry(entry.bonus, entry.value);
    }
  }

  void clear() {
    contents.clear();
  }

  Bonus? findBonus(GetValue<bool> toBool) {
    for (final entry in this) {
      if (toBool(entry.value) == true) {
        return entry.bonus;
      }
    }
    return null;
  }

  BonusMap<T> toMap<T extends Object>(GetValue<T> toValue) {
    final BonusMap<T> output = {};
    for (final entry in this) {
      final value = toValue(entry.value);
      if (value != null) {
        output[entry.bonus] = value;
      }
    }
    return output;
  }

  Bonuses operator +(Bonuses other) {
    return Bonuses(Map.of(contents))..addAll(other);
  }

  @override
  Iterator<BonusEntry<Effect>> get iterator =>
      BonusEntryIterator(contents.entries.iterator);
}

class IntBonuses extends Iterable<BonusEntry<int>> {
  final BonusMap<int> contents;

  const IntBonuses([this.contents = const {}]);

  int get total => contents.values.fold(0, (sum, value) => sum + value);

  IntBonuses operator +(IntBonuses other) {
    final map = Map.of(contents);
    for (final entry in other) {
      final stacks = entry.bonus.stacks;
      map.update(
        entry.bonus,
        (value) => stacks ? value + entry.value : max(value, entry.value),
        ifAbsent: () => entry.value,
      );
    }
    return IntBonuses(map);
  }

  @override
  Iterator<BonusEntry<int>> get iterator =>
      BonusEntryIterator(contents.entries.iterator);

  @override
  String toString() => isEmpty ? "" : bonusText(total);
}

class PercentBonuses extends Iterable<BonusEntry<Percent>> {
  final BonusMap<Percent> contents;

  const PercentBonuses([this.contents = const {}]);

  Percent get total {
    return contents.values.fold(
      const Percent(),
      (sum, value) => sum + value,
    );
  }

  @override
  Iterator<BonusEntry<Percent>> get iterator =>
      BonusEntryIterator(contents.entries.iterator);
}

class MultiplierBonuses extends Iterable<BonusEntry<Multiplier>> {
  final BonusMap<Multiplier> contents;

  const MultiplierBonuses([this.contents = const {}]);

  Multiplier get total {
    return contents.values.fold(
      const Multiplier(0),
      (sum, value) => sum + value,
    );
  }

  @override
  Iterator<BonusEntry<Multiplier>> get iterator =>
      BonusEntryIterator(contents.entries.iterator);
}

class DiceBonuses extends Iterable<BonusEntry<Dice>> {
  final BonusMap<Dice> contents;

  DiceBonuses([BonusMap<Dice>? contents]) : contents = contents ?? {};

  int get maxTotal => Dice.maxTotal(contents.values);
  Range get range => Dice.totalRange(contents.values);

  BonusMap<Dice> findWithSides(int sides) {
    return Map.fromEntries([
      for (final entry in contents.entries)
        if (entry.value.sides == sides) entry,
    ]);
  }

  void add(Bonus bonus, Dice dice) {
    contents[bonus] = dice;
  }

  DiceRollBonuses roll() => _map((dice) => dice.roll());
  DiceRollBonuses rollMax() => _map((dice) => dice.rollMax());

  DiceRollBonuses _map(DiceRoll Function(Dice) fn) {
    return DiceRollBonuses(contents.map((key, value) {
      return MapEntry(key, fn(value));
    }));
  }

  @override
  Iterator<BonusEntry<Dice>> get iterator =>
      BonusEntryIterator(contents.entries.iterator);

  @override
  String toString() => contents.values.fold("", (str, dice) => "$str+$dice");
}

class DiceRollBonuses extends Iterable<BonusEntry<DiceRoll>> {
  final BonusMap<DiceRoll> contents;

  const DiceRollBonuses([this.contents = const {}]);

  void add(Bonus bonus, DiceRoll dice) {
    contents[bonus] = dice;
  }

  IntBonuses get totals {
    return IntBonuses(contents.map((key, value) {
      return MapEntry(key, value.total);
    }));
  }

  @override
  Iterator<BonusEntry<DiceRoll>> get iterator =>
      BonusEntryIterator(contents.entries.iterator);
}

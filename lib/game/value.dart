import 'package:dungeons/game/effect.dart';
import 'package:dungeons/game/effects.dart';
import 'package:dungeons/utility/bonus_text.dart';
import 'package:dungeons/utility/dice.dart';
import 'package:dungeons/utility/percent.dart';
import 'package:dungeons/utility/range.dart';

class IntValue implements Comparable<IntValue> {
  final int base;
  final IntEffects bonuses;

  const IntValue({
    this.base = 0,
    this.bonuses = const IntEffects(),
  });

  int get bonus => bonuses.total;
  int get total => base + bonus;

  void addBonus(Effect effect, int b) {
    bonuses.add(effect, b);
  }

  bool operator >(IntValue other) => total > other.total;

  @override
  String toString() => total.toString();

  @override
  int compareTo(IntValue other) => total - other.total;
}

class PercentValue {
  final Percent base;
  final PercentEffects bonuses;
  final PercentEffects scaling;

  const PercentValue({
    this.base = const Percent(),
    this.bonuses = const PercentEffects(),
    this.scaling = const PercentEffects(),
  });

  Percent get bonus => bonuses.total;
  Percent get unscaled => base + bonus;
  Percent get scaleBonus =>
      scaling.isEmpty ? const Percent() : scaling.total.of(unscaled);
  Percent get total => unscaled + scaleBonus;

  PercentRoll roll() => total.roll();

  @override
  String toString() => total.toString();
}

class DiceValue {
  final Dice base;
  final IntValue bonus;

  const DiceValue({required this.base, this.bonus = const IntValue()});

  Range get range => base.range + bonus.total;

  DiceRollValue roll() => DiceRollValue(base.roll(), bonus);
  DiceRollValue rollMax() => DiceRollValue(base.rollMax(), bonus);

  @override
  String toString() => '$base${bonusText(bonus.total)}';
}

class DiceRollValue {
  final DiceRoll base;
  final IntValue bonus;

  const DiceRollValue(this.base, this.bonus);

  int get total => base.total + bonus.total;

  IntValue get value {
    return IntValue(
      base: base.total + bonus.base,
      bonuses: bonus.bonuses,
    );
  }

  @override
  String toString() => total.toString();
}

import "package:dungeons/utility/monoids.dart";

sealed class BonusValue<T extends Object, V extends Monoid> {
  T get target;
  V get value;
}

enum IntBonusTo {
  strength,
  agility,
  intellect,
  armor,
  damage,
  initiative,
  stressCap,
}

final class IntBonus implements BonusValue<IntBonusTo, Int> {
  @override
  final IntBonusTo target;
  final int amount;

  const IntBonus(this.target, this.amount);

  const IntBonus.strength(int value) : this(IntBonusTo.strength, value);
  const IntBonus.agility(int value) : this(IntBonusTo.agility, value);
  const IntBonus.intellect(int value) : this(IntBonusTo.intellect, value);
  const IntBonus.armor(int value) : this(IntBonusTo.armor, value);
  const IntBonus.damage(int value) : this(IntBonusTo.damage, value);
  const IntBonus.initiative(int value) : this(IntBonusTo.initiative, value);
  const IntBonus.stressCap(int value) : this(IntBonusTo.stressCap, value);

  @override
  Int get value => Int(amount);
}

enum PercentBonusTo { toHit, criticalHit, resist }

final class PercentBonus implements BonusValue<PercentBonusTo, Percent> {
  @override
  final PercentBonusTo target;
  @override
  final Percent value;

  const PercentBonus(this.target, this.value);

  const PercentBonus.toHit(Percent value) : this(PercentBonusTo.toHit, value);
  const PercentBonus.criticalHit(Percent value)
      : this(PercentBonusTo.criticalHit, value);
  const PercentBonus.resist(Percent value) : this(PercentBonusTo.resist, value);
}

enum MultiplierBonusTo { dodge }

final class MultiplierBonus
    implements BonusValue<MultiplierBonusTo, Multiplier> {
  @override
  final MultiplierBonusTo target;
  @override
  final Multiplier value;

  const MultiplierBonus(this.target, this.value);

  const MultiplierBonus.dodge(Multiplier value)
      : this(MultiplierBonusTo.dodge, value);
}

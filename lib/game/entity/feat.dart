import "package:dungeons/game/entity/bonus_value.dart";
import "package:dungeons/utility/dice.dart";
import "package:dungeons/utility/monoids.dart";

enum Feat {
  weaponFocus(
    text: "Weapon Focus",
    trained: FeatValue(
      bonuses: [
        PercentBonus.toHit(Percent(2)),
        IntBonus.damage(1),
      ],
      reserveStress: 1,
    ),
    expert: FeatValue(
      bonuses: [
        PercentBonus.toHit(Percent(4)),
        PercentBonus.criticalHit(Percent(5)),
        IntBonus.damage(2),
      ],
      reserveStress: 2,
    ),
  ),
  sneakAttack(
    text: "Sneak Attack",
    trained: FeatValue(dice: Dice(1, 6)),
    expert: FeatValue(dice: Dice(2, 6)),
  );

  final String text;
  final FeatValue trained;
  final FeatValue expert;

  const Feat({
    required this.text,
    required this.trained,
    required this.expert,
  });

  FeatValue valueFor(FeatTier tier) {
    switch (tier) {
      case FeatTier.trained:
        return trained;
      case FeatTier.expert:
        return expert;
    }
  }

  @override
  String toString() => text;
}

enum FeatTier {
  trained("Trained"),
  expert("Expert");

  final String text;

  const FeatTier(this.text);

  @override
  String toString() => text;

  static FeatTier forLevel(int level) => level < 5 ? trained : expert;
}

class FeatValue {
  final List<BonusValue> bonuses;
  final int? reserveStress;
  final Dice? dice;

  const FeatValue({
    this.bonuses = const [],
    this.reserveStress,
    this.dice,
  });
}

class FeatSlot {
  final Feat feat;
  final FeatTier tier;

  const FeatSlot(this.feat, this.tier);

  FeatValue get value => feat.valueFor(tier);

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode => Object.hash(feat, tier);

  @override
  String toString() => tier == FeatTier.trained ? "$feat" : "$tier $feat";
}

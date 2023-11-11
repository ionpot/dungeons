import "package:dungeons/game/effect.dart";
import "package:dungeons/utility/dice.dart";
import "package:dungeons/utility/percent.dart";

enum Feat {
  weaponFocus(
    text: "Weapon Focus",
    trained: FeatValue(
      effect: Effect(hitChance: Percent(2), damage: 1),
      reserveStress: 1,
    ),
    expert: FeatValue(
      effect: Effect(
        hitChance: Percent(4),
        criticalHitChance: Percent(5),
        damage: 2,
      ),
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
  final Effect? effect;
  final int? reserveStress;
  final Dice? dice;

  const FeatValue({this.effect, this.reserveStress, this.dice});
}

class FeatSlot {
  final Feat feat;
  final FeatTier tier;

  const FeatSlot(this.feat, this.tier);

  FeatValue get value => feat.valueFor(tier);

  @override
  bool operator ==(dynamic other) => hashCode == other.hashCode;

  @override
  int get hashCode => Object.hash(feat, tier);

  @override
  String toString() => tier == FeatTier.trained ? "$feat" : "$tier $feat";
}

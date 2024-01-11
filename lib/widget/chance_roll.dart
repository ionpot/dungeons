import "package:dungeons/game/combat/chance_roll.dart";
import "package:dungeons/game/entity/value.dart";
import "package:dungeons/game/text.dart";
import "package:dungeons/utility/monoids.dart";
import "package:dungeons/widget/value_span.dart";
import "package:flutter/widgets.dart";

class ChanceRollText extends StatelessWidget {
  final String name;
  final Value<Percent> chance;
  final ChanceRoll roll;
  final bool critical;

  const ChanceRollText(
    this.name,
    this.chance,
    this.roll, {
    super.key,
    this.critical = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: "$name ("),
          ValueSpan(chance),
          TextSpan(text: ") $_outcome"),
        ],
      ),
    );
  }

  String get _outcome {
    return chanceRollText(roll, chance.total, critical);
  }
}

import "package:dungeons/game/chance_roll.dart";
import "package:dungeons/game/log.dart";
import "package:dungeons/game/value.dart";
import "package:dungeons/utility/monoids.dart";
import "package:dungeons/widget/value.dart";
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
    return Log.chanceRollText(roll, chance.total, critical);
  }
}

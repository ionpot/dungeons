import 'package:dungeons/game/combat.dart';
import 'package:dungeons/game/entity.dart';
import 'package:dungeons/widget/button.dart';
import 'package:dungeons/widget/entity_stats.dart';
import 'package:dungeons/widget/section.dart';
import 'package:flutter/widgets.dart';

class CombatScreen extends StatefulWidget {
  final Combat combat;

  const CombatScreen(this.combat, {super.key});

  factory CombatScreen.withPlayer(Entity player) =>
      CombatScreen(Combat(player));

  @override
  State<CombatScreen> createState() => _CombatScreenState();
}

class _CombatScreenState extends State<CombatScreen> {
  @override
  Widget build(BuildContext context) {
    final combat = widget.combat;
    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 300,
                child: EntityStats(combat.player),
              ),
              EntityStats(combat.enemy),
            ],
          ),
          Section.below(
            child: Button(
              text: 'Next',
              onClick: () {
                setState(() {
                  combat.enemy.randomize();
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

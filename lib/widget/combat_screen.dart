import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/entity_race.dart';
import 'package:dungeons/widget/button.dart';
import 'package:dungeons/widget/entity_stats.dart';
import 'package:dungeons/widget/section.dart';
import 'package:flutter/widgets.dart';

class CombatScreen extends StatefulWidget {
  final Entity player;
  final Entity enemy = Entity('Enemy', race: orc)..randomize();

  CombatScreen({super.key, required this.player});

  @override
  State<CombatScreen> createState() => _CombatScreenState();
}

class _CombatScreenState extends State<CombatScreen> {
  @override
  Widget build(BuildContext context) {
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
                child: EntityStats(widget.player),
              ),
              EntityStats(widget.enemy),
            ],
          ),
          Section.below(
            child: Button(
              text: 'Next',
              onClick: () {
                setState(() {
                  widget.enemy.randomize();
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

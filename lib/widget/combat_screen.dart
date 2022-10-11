import 'package:dungeons/game/combat.dart';
import 'package:dungeons/game/entity.dart';
import 'package:dungeons/widget/button.dart';
import 'package:dungeons/widget/combat_status.dart';
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
  late Combat _combat;

  @override
  void initState() {
    super.initState();
    _combat = widget.combat;
  }

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
                child: EntityStats(_combat.player),
              ),
              EntityStats(_combat.enemy),
            ],
          ),
          Section.below(
            child: Row(
              children: [
                Button(
                  text: 'Next',
                  onClick: () {
                    setState(() {
                      _combat = Combat(_combat.player);
                    });
                  },
                ),
                Section.after(child: CombatStatus(turn: _combat.turn)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

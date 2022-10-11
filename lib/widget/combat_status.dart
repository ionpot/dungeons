import 'package:dungeons/game/entity.dart';
import 'package:flutter/widgets.dart';

class CombatStatus extends StatelessWidget {
  final Entity turn;

  const CombatStatus({super.key, required this.turn});

  @override
  Widget build(BuildContext context) {
    return Text('${turn.name} goes first.');
  }
}

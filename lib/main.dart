import 'package:dungeons/game/log.dart';
import 'package:dungeons/widget/colors.dart';
import 'package:dungeons/widget/combat_screen.dart';
import 'package:dungeons/widget/create_screen.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(TheApp());
}

class TheApp extends StatefulWidget {
  final log = Log.toFile('dungeons.log');

  TheApp({super.key});

  @override
  State<TheApp> createState() => TheAppState();
}

class TheAppState extends State<TheApp> {
  Widget? screen;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: black,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: _buildScreen(),
      ),
    );
  }

  Widget _buildScreen() {
    if (screen != null) return screen!;
    return CreateScreen(
      onDone: (entity) {
        widget.log.entity(entity);
        setState(() {
          screen = CombatScreen.withPlayer(entity);
        });
      },
    );
  }
}

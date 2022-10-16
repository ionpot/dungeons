import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/log.dart';
import 'package:dungeons/widget/colors.dart';
import 'package:dungeons/widget/combat_screen.dart';
import 'package:dungeons/widget/create_screen.dart';
import 'package:flutter/widgets.dart';

void main() {
  final log = Log.toFile('dungeons.log')..file.writeln('Dungeons');
  runApp(TheApp(log));
}

class TheApp extends StatefulWidget {
  final Log log;

  const TheApp(this.log, {super.key});

  @override
  State<TheApp> createState() => TheAppState();
}

class TheAppState extends State<TheApp> {
  late Widget _screen;

  @override
  void initState() {
    super.initState();
    _screen = _createScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: black,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: _screen,
      ),
    );
  }

  Widget _createScreen() {
    return CreateScreen(
      onDone: (player) {
        _toScreen(_combatScreen(player));
      },
    );
  }

  Widget _combatScreen(Entity player) {
    return CombatScreen.withPlayer(
      player,
      key: UniqueKey(),
      log: widget.log,
      onDone: (player) {
        if (player.alive) {
          _toScreen(_combatScreen(player));
        } else {
          _toScreen(_createScreen());
        }
      },
    );
  }

  void _toScreen(Widget screen) {
    setState(() {
      _screen = screen;
    });
  }
}

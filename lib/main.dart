import "package:dungeons/game/log.dart";
import "package:dungeons/screens.dart";
import "package:dungeons/widget/colors.dart";
import "package:dungeons/widget/screen_overlay.dart";
import "package:flutter/widgets.dart";

void main() {
  runApp(const TheApp());
}

class TheApp extends StatefulWidget {
  const TheApp({super.key});

  @override
  State<TheApp> createState() => TheAppState();
}

class TheAppState extends State<TheApp> {
  late Widget _screen;

  @override
  void initState() {
    super.initState();
    final screens = Screens(
      log: Log.toFile("dungeons.log", title: "Dungeons"),
      onNext: (Widget screen) {
        setState(() => _screen = screen);
      },
    );
    _screen = screens.first;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        color: black,
        child: ScreenOverlay(child: _screen),
      ),
    );
  }
}

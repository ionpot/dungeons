import 'package:dungeons/game/log.dart';
import 'package:dungeons/widget/colors.dart';
import 'package:dungeons/widget/screens.dart';
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
    _screen = Screens(log: widget.log, onNext: _onNext).first;
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

  void _onNext(Widget screen) {
    setState(() {
      _screen = screen;
    });
  }
}

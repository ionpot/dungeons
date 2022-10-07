import 'dart:io';

import 'package:dungeons/game/log.dart';
import 'package:dungeons/widget/colors.dart';
import 'package:dungeons/widget/create_screen.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(TheApp());
}

class TheApp extends StatelessWidget {
  final log = Log.toFile('dungeons.log');

  TheApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: black,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: CreateScreen(
          onDone: (entity) async {
            log.entity(entity);
            await log.end();
            exit(0);
          },
        ),
      ),
    );
  }
}

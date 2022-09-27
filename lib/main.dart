import 'dart:io';

import 'package:dungeons/widget/colors.dart';
import 'package:dungeons/widget/create_screen.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(const TheApp());
}

class TheApp extends StatelessWidget {
  const TheApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: SizedBox.expand(
        child: Container(
          color: black,
          child: CreateScreen(
            onDone: () => exit(0),
          ),
        ),
      ),
    );
  }
}

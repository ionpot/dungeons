import 'dart:io';

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
          color: const Color(0xFF000000),
          child: CreateScreen(
            onDone: () => exit(0),
          ),
        ),
      ),
    );
  }
}

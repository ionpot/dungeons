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
    return Container(
      color: black,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: CreateScreen(
          onDone: () => exit(0),
        ),
      ),
    );
  }
}

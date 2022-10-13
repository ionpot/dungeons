import 'package:flutter/widgets.dart';

class BoldText extends StatelessWidget {
  final String text;

  const BoldText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }
}

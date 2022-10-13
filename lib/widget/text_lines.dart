import 'package:flutter/widgets.dart';

class TextLines extends StatelessWidget {
  final List<String> lines;

  const TextLines(this.lines, {super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.vertical,
      spacing: 8,
      children: [for (final text in lines) Text(text)],
    );
  }
}

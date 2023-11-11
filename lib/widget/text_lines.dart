import "package:dungeons/widget/spaced.dart";
import "package:flutter/widgets.dart";

class TextLines extends StatelessWidget {
  final List<Widget> lines;

  const TextLines(this.lines, {super.key});

  factory TextLines.plain(List<String> lines) =>
      TextLines([for (final text in lines) Text(text)]);

  @override
  Widget build(BuildContext context) {
    return buildSpacedColumn(spacing: 8, children: lines);
  }
}

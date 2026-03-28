import "package:dungeons/widget/spaced.dart";
import "package:flutter/widgets.dart";

class TextLines extends StatelessWidget {
  final List<Widget> lines;

  TextLines(Iterable<Widget> lines, {super.key}) : lines = lines.toList();

  factory TextLines.plain(Iterable<String> lines) =>
      TextLines(lines.map((text) => Text(text)));

  @override
  Widget build(BuildContext context) {
    return buildSpacedColumn(spacing: 8, children: lines);
  }
}

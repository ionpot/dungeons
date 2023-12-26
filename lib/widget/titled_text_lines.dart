import "package:dungeons/widget/text.dart";
import "package:dungeons/widget/text_lines.dart";
import "package:flutter/widgets.dart";

class TitledTextLines extends StatelessWidget {
  final String title;
  final TextLines lines;

  const TitledTextLines({
    super.key,
    required this.title,
    required this.lines,
  });

  factory TitledTextLines.oneLine({
    required String title,
    required Widget line,
  }) {
    return TitledTextLines(title: title, lines: TextLines([line]));
  }

  factory TitledTextLines.plain({
    required String title,
    required List<String> lines,
  }) {
    return TitledTextLines(title: title, lines: TextLines.plain(lines));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BoldText(title),
        const SizedBox(height: 12),
        lines,
      ],
    );
  }
}

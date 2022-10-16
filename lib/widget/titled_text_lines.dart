import 'package:dungeons/widget/bold_text.dart';
import 'package:dungeons/widget/text_lines.dart';
import 'package:flutter/widgets.dart';

class TitledTextLines extends StatelessWidget {
  final String title;
  final List<String> lines;

  const TitledTextLines({
    super.key,
    required this.title,
    required this.lines,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BoldText(title),
        const SizedBox(height: 12),
        TextLines(lines),
      ],
    );
  }
}

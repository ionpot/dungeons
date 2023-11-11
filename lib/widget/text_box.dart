import "package:dungeons/widget/colors.dart";
import "package:flutter/widgets.dart";

class TextBox extends StatelessWidget {
  final Color? color;
  final String text;

  const TextBox({
    super.key,
    required this.text,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? white;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: c),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: TextStyle(color: c)),
    );
  }
}

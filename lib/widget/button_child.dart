import 'package:flutter/widgets.dart';

class ButtonChild extends StatelessWidget {
  final int color;
  final String text;

  const ButtonChild({
    super.key,
    required this.text,
    this.color = 0xFFFFFFFF,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: Color(color),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: TextStyle(color: Color(color))),
    );
  }
}

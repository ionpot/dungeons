import 'package:flutter/widgets.dart';

class ButtonChild extends StatelessWidget {
  final Color color;
  final String text;

  const ButtonChild({
    super.key,
    required this.text,
    this.color = const Color(0xFFFFFFFF),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: color,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: TextStyle(color: color)),
    );
  }
}

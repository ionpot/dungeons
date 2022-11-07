import 'package:dungeons/widget/text_box.dart';
import 'package:dungeons/widget/click_dent.dart';
import 'package:dungeons/widget/colors.dart';
import 'package:flutter/widgets.dart';

class Button extends StatelessWidget {
  final String text;
  final VoidCallback onClick;
  final bool clickable;
  final bool active;
  final Color? color;

  const Button(
    this.text, {
    super.key,
    required this.onClick,
    this.clickable = true,
    this.active = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ClickDent(
      enabled: clickable,
      child: GestureDetector(
        onTap: () {
          if (clickable) onClick();
        },
        child: TextBox(
          text: text,
          color: active ? yellow : color,
        ),
      ),
    );
  }
}

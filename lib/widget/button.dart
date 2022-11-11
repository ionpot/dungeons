import 'package:dungeons/widget/text_box.dart';
import 'package:dungeons/widget/click_dent.dart';
import 'package:dungeons/widget/colors.dart';
import 'package:flutter/widgets.dart';

class Button extends StatelessWidget {
  final String text;
  final VoidCallback onClick;
  final bool clickable;
  final bool active;
  final bool disabled;
  final Color? color;

  const Button(
    this.text, {
    super.key,
    required this.onClick,
    this.clickable = true,
    this.active = false,
    this.disabled = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final clickable_ = disabled ? false : clickable;
    return ClickDent(
      enabled: clickable_,
      child: GestureDetector(
        onTap: () {
          if (clickable_) onClick();
        },
        child: Opacity(
          opacity: disabled ? 0.5 : 1.0,
          child: TextBox(
            text: text,
            color: active ? green : color,
          ),
        ),
      ),
    );
  }
}

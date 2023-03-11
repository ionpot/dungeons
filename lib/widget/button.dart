import 'package:dungeons/widget/text_box.dart';
import 'package:dungeons/widget/click_dent.dart';
import 'package:dungeons/widget/colors.dart';
import 'package:flutter/widgets.dart';

class Button extends StatelessWidget {
  final String text;
  final VoidCallback onClick;
  final bool clickable;
  final bool active;
  final bool enabled;
  final Color? color;

  const Button({
    super.key,
    required this.text,
    required this.onClick,
    this.clickable = true,
    this.active = false,
    this.enabled = true,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final clickable_ = enabled ? clickable : false;
    return ClickDent(
      enabled: clickable_,
      child: GestureDetector(
        onTap: () {
          if (clickable_) onClick();
        },
        child: Opacity(
          opacity: enabled ? 1.0 : 0.5,
          child: TextBox(
            text: text,
            color: active ? green : color,
          ),
        ),
      ),
    );
  }
}

import 'package:dungeons/widget/button_child.dart';
import 'package:dungeons/widget/click_dent.dart';
import 'package:dungeons/widget/colors.dart';
import 'package:flutter/widgets.dart';

class Button extends StatelessWidget {
  final String text;
  final VoidCallback onClick;
  final bool clickable;
  final bool active;

  const Button({
    super.key,
    required this.text,
    required this.onClick,
    this.clickable = true,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return ClickDent(
      enabled: clickable,
      child: GestureDetector(
        onTap: () => {if (clickable) onClick()},
        child: ButtonChild(
          text: text,
          color: active ? yellow : white,
        ),
      ),
    );
  }
}

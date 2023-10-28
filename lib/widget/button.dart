import 'package:dungeons/widget/clickable.dart';
import 'package:dungeons/widget/text_box.dart';
import 'package:dungeons/widget/colors.dart';
import 'package:flutter/widgets.dart';

class Button extends StatelessWidget {
  final String text;
  final bool enabled;
  final VoidCallback onClick;
  final ClickableState? state;
  final Color? color;

  const Button({
    super.key,
    required this.text,
    required this.onClick,
    this.enabled = true,
    this.state,
    this.color,
  });

  bool get active => state == ClickableState.active;

  @override
  Widget build(BuildContext context) {
    return Clickable(
      state:
          state ?? (enabled ? ClickableState.enabled : ClickableState.disabled),
      onClick: onClick,
      child: TextBox(
        text: text,
        color: active ? green : color,
      ),
    );
  }
}

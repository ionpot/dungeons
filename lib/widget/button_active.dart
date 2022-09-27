import 'package:dungeons/widget/button_child.dart';
import 'package:dungeons/widget/click_dent.dart';
import 'package:dungeons/widget/colors.dart';
import 'package:flutter/widgets.dart';

class ButtonActive extends StatefulWidget {
  final String text;
  final ValueChanged<bool> onClick;
  final bool clickable;

  const ButtonActive({
    super.key,
    required this.text,
    required this.onClick,
    this.clickable = true,
  });

  @override
  State<ButtonActive> createState() => _ButtonActiveState();
}

class _ButtonActiveState extends State<ButtonActive> {
  bool _active = false;

  _ButtonActiveState();

  @override
  Widget build(BuildContext context) {
    return ClickDent(
      enabled: widget.clickable,
      child: GestureDetector(
        onTap: () {
          if (!widget.clickable) return;
          setState(() => {_active = !_active});
          widget.onClick(_active);
        },
        child: ButtonChild(
          text: widget.text,
          color: _active ? yellow : white,
        ),
      ),
    );
  }
}

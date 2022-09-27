import 'package:dungeons/widget/button_child.dart';
import 'package:flutter/widgets.dart';

class Button extends StatefulWidget {
  final String text;
  final VoidCallback onClick;
  final bool clickable;

  const Button({
    super.key,
    required this.text,
    required this.onClick,
    this.clickable = true,
  });

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  bool _heldDown = false;

  _ButtonState();

  double _checkMargin(double margin) {
    if (widget.clickable && _heldDown) {
      return margin;
    }
    return 0;
  }

  @override
  Widget build(BuildContext _) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _heldDown = true),
      onTapUp: (_) => setState(() => _heldDown = false),
      onTapCancel: () => setState(() => _heldDown = false),
      onTap: () => {if (widget.clickable) widget.onClick()},
      child: Container(
        margin: EdgeInsets.only(left: _checkMargin(2), top: _checkMargin(4)),
        child: ButtonChild(text: widget.text),
      ),
    );
  }
}

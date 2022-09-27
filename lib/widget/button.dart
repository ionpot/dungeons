import 'package:flutter/widgets.dart';

class Button extends StatefulWidget {
  final Widget child;
  final VoidCallback onClick;
  final bool clickable;

  const Button({
    super.key,
    required this.child,
    required this.onClick,
    this.clickable = true,
  });

  Button.text(
    String text, {
    key,
    required onClick,
    clickable = true,
  }) : this(
          key: key,
          onClick: onClick,
          clickable: clickable,
          child: Text(text),
        );

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
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: const Color(0xFFFFFFFF),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: widget.child,
      ),
    );
  }
}

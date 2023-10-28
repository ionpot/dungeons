import 'package:flutter/widgets.dart';

enum ClickableState { active, disabled, enabled }

class Clickable extends StatefulWidget {
  final ClickableState state;
  final Widget child;
  final VoidCallback onClick;

  const Clickable({
    super.key,
    required this.onClick,
    required this.child,
    this.state = ClickableState.enabled,
  });

  bool get enabled => state == ClickableState.enabled;
  bool get disabled => state == ClickableState.disabled;

  @override
  State<Clickable> createState() => _ClickableState();
}

class _ClickableState extends State<Clickable> {
  bool _heldDown = false;

  _ClickableState();

  double _check(double offset) {
    if (widget.enabled && _heldDown) {
      return offset;
    }
    return 0;
  }

  @override
  Widget build(BuildContext _) {
    return GestureDetector(
      onTap: () {
        if (widget.enabled) widget.onClick();
      },
      onTapDown: (_) => setState(() => _heldDown = true),
      onTapUp: (_) => setState(() => _heldDown = false),
      onTapCancel: () => setState(() => _heldDown = false),
      child: Transform.translate(
        offset: Offset(_check(2), _check(4)),
        child: Opacity(
          opacity: widget.disabled ? 0.5 : 1.0,
          child: widget.child,
        ),
      ),
    );
  }
}

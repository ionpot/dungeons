import 'package:flutter/widgets.dart';

class ClickDent extends StatefulWidget {
  final Widget child;
  final bool enabled;

  const ClickDent({
    super.key,
    required this.child,
    this.enabled = true,
  });

  @override
  State<ClickDent> createState() => _ClickDentState();
}

class _ClickDentState extends State<ClickDent> {
  bool _heldDown = false;

  _ClickDentState();

  double _check(double offset) {
    if (widget.enabled && _heldDown) {
      return offset;
    }
    return 0;
  }

  @override
  Widget build(BuildContext _) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _heldDown = true),
      onTapUp: (_) => setState(() => _heldDown = false),
      onTapCancel: () => setState(() => _heldDown = false),
      child: Transform.translate(
        offset: Offset(_check(2), _check(4)),
        child: widget.child,
      ),
    );
  }
}

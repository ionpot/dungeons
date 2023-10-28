import 'package:flutter/widgets.dart';

class TopLeft extends StatelessWidget {
  final Offset offset;
  final Widget child;

  const TopLeft(this.offset, {super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Positioned(left: offset.dx, top: offset.dy, child: child);
  }
}

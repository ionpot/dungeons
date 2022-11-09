import 'package:flutter/widgets.dart';

class SizedWrap extends StatelessWidget {
  final Widget? child;
  final List<Widget>? children;
  final double? width;

  const SizedWrap({super.key, this.child, this.children, this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Wrap(children: children ?? [if (child != null) child!]),
    );
  }
}

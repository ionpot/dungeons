import 'package:flutter/widgets.dart';

class Section extends StatelessWidget {
  final double left;
  final double top;
  final Widget? child;

  const Section({super.key, this.child, this.left = 60, this.top = 40});
  const Section.after({key, child}) : this(key: key, child: child, top: 0);
  const Section.below({key, child, double left = 0})
      : this(key: key, child: child, left: left);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: left, top: top),
      child: child,
    );
  }
}

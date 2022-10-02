import 'package:flutter/widgets.dart';

Widget buildSpacedRow({
  required List<Widget> children,
  required double spacing,
}) {
  List<Widget> ls = [];
  for (final child in children) {
    if (ls.isEmpty) {
      ls.add(child);
    } else {
      ls.add(Padding(
        padding: EdgeInsets.only(left: spacing),
        child: child,
      ));
    }
  }
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: ls,
  );
}

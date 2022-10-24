import 'package:flutter/widgets.dart';

Widget buildSpacedRow({
  required List<Widget> children,
  double spacing = 60,
}) {
  return Wrap(
    spacing: spacing,
    children: children,
  );
}

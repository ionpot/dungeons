import "package:dungeons/widget/radio_button.dart";
import "package:dungeons/widget/spaced.dart";
import "package:flutter/widgets.dart";

class RadioGroup extends StatelessWidget {
  final List<RadioButton> children;

  @override
  Widget build(BuildContext context) {
    return buildSpacedRow(spacing: 10, children: children);
  }
}

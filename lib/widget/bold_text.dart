import 'package:flutter/widgets.dart';

class BoldText extends StatelessWidget {
  final Widget widget;

  BoldText(String text, {super.key}) : widget = Text(text, style: style);

  BoldText.fromSpan(TextSpan span, {super.key})
      : widget = Text.rich(span, style: style);

  @override
  Widget build(BuildContext context) => widget;

  static const style = TextStyle(fontWeight: FontWeight.bold);
}

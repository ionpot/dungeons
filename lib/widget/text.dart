import "package:flutter/widgets.dart";

const bold = TextStyle(fontWeight: FontWeight.bold);

class ColoredText extends Text {
  ColoredText(Object value, Color? color, {super.key, TextStyle? style})
      : super("$value", style: TextStyle(color: color).merge(style));
}

class BoldText extends ColoredText {
  BoldText(Object value, {super.key, Color? color, TextStyle? style})
      : super(value, color, style: bold.merge(style));
}

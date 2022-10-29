import 'package:dungeons/game/stress.dart';
import 'package:dungeons/game/value.dart';
import 'package:dungeons/widget/colors.dart';
import 'package:flutter/widgets.dart';

TextStyle _style(Color? color, {bool bold = false}) {
  return TextStyle(
    color: color,
    fontWeight: bold ? FontWeight.bold : null,
  );
}

TextStyle coloredIntStyle(int value, {bool bold = false}) {
  return _style(colorOf(value), bold: bold);
}

TextStyle coloredIntValueStyle(IntValue value, {bool bold = false}) {
  return _style(colorOf(value.bonus), bold: bold);
}

TextStyle coloredPercentValueStyle(PercentValue value, {bool bold = false}) {
  return coloredIntStyle(value.bonus.value, bold: bold);
}

TextStyle coloredStressCapStyle(Stress stress, {bool bold = false}) {
  return _style(stress.reserved > 0 ? yellow : null, bold: bold);
}

TextStyle coloredDiceValueStyle(DiceValue value, {bool bold = false}) {
  return coloredIntValueStyle(value.bonus, bold: bold);
}

Text coloredIntText(IntValue value, {bool bold = false}) {
  return Text(
    value.total.toString(),
    style: coloredIntValueStyle(value, bold: bold),
  );
}

TextSpan coloredIntSpan(IntValue value, {bool bold = false}) {
  return TextSpan(
    text: value.total.toString(),
    style: coloredIntValueStyle(value, bold: bold),
  );
}

Text coloredPercentText(PercentValue value, {bool bold = false}) {
  return Text(
    value.total.toString(),
    style: coloredPercentValueStyle(value, bold: bold),
  );
}

TextSpan coloredPercentSpan(PercentValue value, {bool bold = false}) {
  return TextSpan(
    text: value.total.toString(),
    style: coloredPercentValueStyle(value, bold: bold),
  );
}

TextSpan coloredStressCapSpan(Stress stress, {bool bold = false}) {
  return TextSpan(
    text: stress.currentCap.toString(),
    style: coloredStressCapStyle(stress, bold: bold),
  );
}

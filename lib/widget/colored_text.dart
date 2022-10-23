import 'package:dungeons/game/stress.dart';
import 'package:dungeons/game/value.dart';
import 'package:dungeons/widget/colors.dart';
import 'package:flutter/widgets.dart';

TextStyle coloredTextStyle(int value, {bool bold = false}) {
  return TextStyle(
    color: colorOf(value),
    fontWeight: bold ? FontWeight.bold : null,
  );
}

TextStyle coloredStressCapStyle(Stress stress, {bool bold = false}) {
  return TextStyle(
    color: stress.reserved > 0 ? yellow : null,
    fontWeight: bold ? FontWeight.bold : null,
  );
}

Text coloredIntText(IntValue value, {bool bold = false}) {
  return Text(
    value.total.toString(),
    style: coloredTextStyle(value.bonus, bold: bold),
  );
}

TextSpan coloredIntSpan(IntValue value, {bool bold = false}) {
  return TextSpan(
    text: value.total.toString(),
    style: coloredTextStyle(value.bonus, bold: bold),
  );
}

Text coloredPercentText(PercentValue value, {bool bold = false}) {
  return Text(
    value.total.toString(),
    style: coloredTextStyle(value.bonus.value, bold: bold),
  );
}

TextSpan coloredPercentSpan(PercentValue value, {bool bold = false}) {
  return TextSpan(
    text: value.total.toString(),
    style: coloredTextStyle(value.bonus.value, bold: bold),
  );
}

TextSpan coloredStressCapSpan(Stress stress, {bool bold = false}) {
  return TextSpan(
    text: stress.currentCap.toString(),
    style: coloredStressCapStyle(stress, bold: bold),
  );
}

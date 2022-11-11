import 'package:dungeons/game/source.dart';
import 'package:dungeons/game/stress.dart';
import 'package:dungeons/game/value.dart';
import 'package:dungeons/utility/percent.dart';
import 'package:flutter/widgets.dart';

const black = Color(0xFF000000);
const white = Color(0xFFFFFFFF);
const yellow = Color(0xFFFFFF00);
const green = Color(0xFF00FF00);
const red = Color(0xFFFF0000);

Color? intColor(int i) {
  switch (i.sign) {
    case 1:
      return green;
    case -1:
      return red;
    default:
      return null;
  }
}

Color? percentColor(Percent percent) => intColor(percent.value);
Color? intValueColor(IntValue value) => intColor(value.bonus);
Color? percentValueColor(PercentValue value) => percentColor(value.bonus);
Color? diceValueColor(DiceValue value) => intValueColor(value.bonus);

Color? stressColor(Stress stress) =>
    stress.reserved > 0 ? yellow : intValueColor(stress.cap);

Color? sourceColor(Source source) {
  switch (source) {
    case Source.physical:
      return null;
    case Source.astral:
      return const Color(0xFFFF00FF);
    case Source.cold:
      return const Color(0xFF00F2FF);
    case Source.radiant:
      return yellow;
  }
}

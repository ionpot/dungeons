import 'package:dungeons/game/bonus.dart';
import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/source.dart';
import 'package:dungeons/game/value.dart';
import 'package:dungeons/utility/percent.dart';
import 'package:flutter/widgets.dart';

const black = Color(0xFF000000);
const white = Color(0xFFFFFFFF);
const yellow = Color(0xFFFFFF00);
const gold = Color(0xFFFFC000);
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

Color? doubleColor(double x) => intColor(x.sign.round());

Color? percentColor(Percent percent) => intColor(percent.value);
Color? intValueColor(IntValue value) {
  return intColor(value.bonuses.filter(bonusHasColor).total);
}

Color? percentValueColor(PercentValue value) {
  value = PercentValue(
    base: value.base,
    bonuses: value.bonuses.filter(bonusHasColor),
    multipliers: value.multipliers.filter(bonusHasColor),
  );
  return percentColor(value.multiplierBonus) ?? percentColor(value.bonus);
}

Color? hpColor(Entity e) => e.alive ? null : red;

Color? sourceColor(Source source) {
  switch (source) {
    case Source.physical:
      return null;
    case Source.astral:
      return const Color(0xFFFF00FF);
    case Source.cold:
      return const Color(0xFF00F2FF);
    case Source.lightning:
      return const Color(0xFF8484FF);
    case Source.radiant:
      return yellow;
  }
}

bool bonusHasColor(Bonus bonus) => !ignoreBonusColor(bonus);

bool ignoreBonusColor(Bonus bonus) {
  if (bonus is AttributeBonus) {
    return bonus.base;
  }
  return bonus is ClassBonus;
}

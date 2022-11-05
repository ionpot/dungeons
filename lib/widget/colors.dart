import 'package:dungeons/game/damage.dart';
import 'package:flutter/widgets.dart';

const black = Color(0xFF000000);
const white = Color(0xFFFFFFFF);
const yellow = Color(0xFFFFFF00);
const green = Color(0xFF00FF00);
const red = Color(0xFFFF0000);

Color? colorOf(int i) {
  switch (i.sign) {
    case 1:
      return green;
    case -1:
      return red;
    default:
      return null;
  }
}

Color? damageTypeColor(DamageType type) {
  switch (type) {
    case DamageType.normal:
      return null;
    case DamageType.astral:
      return const Color(0xFFFF00FF);
  }
}

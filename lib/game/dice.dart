import 'dart:math';

int rollDie(int sides) {
  if (sides > 1) {
    return Random().nextInt(sides) + 1;
  }
  if (sides == 1) return sides;
  throw ArgumentError.value(sides, 'sides');
}

int rollDice(int count, int sides) {
  if (count < 0) {
    throw ArgumentError.value(count, 'count');
  }
  int result = 0;
  while (count-- > 0) {
    result += rollDie(sides);
  }
  return result;
}

import 'dart:math';

T pickRandom<T>(List<T> input) {
  if (input.isEmpty) {
    throw ArgumentError.value(input, 'input');
  }
  return input[pickRandomIndex(input.length)];
}

int pickRandomIndex(int count) => (count > 1) ? Random().nextInt(count) : 0;

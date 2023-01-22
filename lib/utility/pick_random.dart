import 'dart:math';

T pickRandom<T>(List<T> input) {
  if (input.isEmpty) {
    throw ArgumentError.value(input, 'input');
  }
  return input[pickRandomIndex(input.length)];
}

T? pickRandomMaybe<T>(List<T> input) {
  if (input.isEmpty) {
    throw ArgumentError.value(input, 'input');
  }
  final i = pickRandomIndex(input.length + 1);
  return i == input.length ? null : input[i];
}

int pickRandomIndex(int count) => (count > 1) ? Random().nextInt(count) : 0;

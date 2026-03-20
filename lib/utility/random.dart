import "dart:math";

T pickRandom<T>(Iterable<T> input) {
  if (input.isEmpty) {
    throw ArgumentError.value(input, "input");
  }
  return input.elementAt(pickRandomIndex(input.length));
}

int pickRandomIndex(int count) => (count > 1) ? Random().nextInt(count) : 0;

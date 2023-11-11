import "dart:math";

T pickRandom<T>(Iterable<T> input) {
  if (input.isEmpty) {
    throw ArgumentError.value(input, "input");
  }
  return input.elementAt(pickRandomIndex(input.length));
}

T? pickRandomMaybe<T>(Iterable<T> input) {
  if (input.isEmpty) {
    return null;
  }
  final i = pickRandomIndex(input.length + 1);
  return i == input.length ? null : input.elementAt(i);
}

int pickRandomIndex(int count) => (count > 1) ? Random().nextInt(count) : 0;

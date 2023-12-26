import "package:dungeons/utility/bonus_text.dart";
import "package:dungeons/utility/fixed_string.dart";

sealed class Monoid implements Comparable<Monoid> {
  const Monoid();

  bool get isEmpty;
  bool get hasValue => !isEmpty;

  Monoid operator +(covariant Monoid other);
  Monoid operator -(covariant Monoid other);

  Monoid get identity;
  Monoid get negate;

  Monoid get half;
  Monoid get quarter => half.half;

  Monoid multiply(Multiplier multiplier);

  int compare(covariant Monoid other);

  Monoid greaterOf(Monoid other) {
    return compareTo(other) == 1 ? this : other;
  }

  int get sign;

  String get signed;

  @override
  int compareTo(Monoid other) {
    return compare(other);
  }

  static T empty<T extends Monoid>() {
    if (T is Int) return Int.zero as T;
    if (T is Percent) return Percent.zero as T;
    if (T is Multiplier) return Multiplier.empty as T;
    throw ArgumentError("Unknown monoid.");
  }
}

extension MonoidIterable<T extends Monoid> on Iterable<T> {
  T get total {
    return fold(Monoid.empty<T>(), (a, b) => a + b as T);
  }
}

final class Int extends Monoid {
  final int value;

  const Int(this.value);

  static const Int zero = Int(0);

  bool contains(int x) => x <= value;

  @override
  bool get isEmpty => value == zero.value;

  @override
  Int get identity => zero;

  @override
  Int get negate => Int(-value);

  @override
  Int operator +(Int other) => Int(value + other.value);

  @override
  Int operator -(Int other) => Int(value - other.value);

  @override
  Int get half => Int(value ~/ 2);

  @override
  Int multiply(Multiplier multiplier) {
    return Int(multiplier.applyTo(value));
  }

  @override
  int get sign => value.sign;

  @override
  String get signed => bonusText(value);

  @override
  int compare(Int other) {
    return value.compareTo(other.value);
  }

  @override
  String toString() => "$value";
}

final class Percent extends Monoid {
  final int value;

  const Percent(this.value);

  static const zero = Percent(0);

  bool get always => value >= 100;
  bool get never => value <= 0;
  bool get maybe => !always && !never;

  bool success(int input) => input <= value;

  Percent invert() => Percent(100 - value);

  @override
  Percent get half => Percent(value ~/ 2);

  @override
  Percent multiply(Multiplier multiplier) {
    return Percent(multiplier.applyTo(value));
  }

  @override
  bool get isEmpty => value == zero.value;

  @override
  Percent get identity => zero;

  @override
  Percent get negate => Percent(-value);

  @override
  Percent operator +(Percent other) => Percent(value + other.value);

  @override
  Percent operator -(Percent other) => Percent(value - other.value);

  @override
  int get sign => value.sign;

  @override
  String get signed => isEmpty ? "" : "${bonusText(value)}%";

  @override
  int compare(Percent other) {
    return value.compareTo(other.value);
  }

  @override
  String toString() => "$value%";
}

final class Multiplier extends Monoid {
  final double value;

  const Multiplier(this.value);

  static const empty = Multiplier(1);

  int applyTo(int input) {
    return (input * value).floor();
  }

  @override
  bool get isEmpty => value == empty.value;

  @override
  Multiplier get identity => empty;

  @override
  Multiplier get negate => Multiplier(-value);

  @override
  Multiplier operator +(Multiplier other) {
    return Multiplier(value + other.value);
  }

  @override
  Multiplier operator -(Multiplier other) {
    return Multiplier(value - other.value);
  }

  @override
  Multiplier get half => Multiplier(value / 2);

  @override
  Multiplier multiply(Multiplier multiplier) {
    return Multiplier(value * multiplier.value);
  }

  @override
  int compare(Multiplier other) {
    return value.compareTo(other.value);
  }

  @override
  int get sign => value.sign.toInt();

  @override
  String get signed {
    if (isEmpty) {
      return "";
    }
    final sign = value < 0 ? "- " : "+";
    return "${sign}x$_fixed";
  }

  @override
  String toString() {
    final sign = value < 0 ? "- " : "";
    return "${sign}x$_fixed";
  }

  String get _fixed => toFixedString(value.abs());
}

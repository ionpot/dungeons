B? ifdef<A, B>(A? a, B? Function(A) f) {
  return a != null ? f(a) : null;
}

T? ifyes<T>(bool? b, T? Function() f) {
  return b == true ? f() : null;
}

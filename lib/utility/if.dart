B? ifdef<A, B>(A? a, B? Function(A) f) {
  return a != null ? f(a) : null;
}

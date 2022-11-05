B? ifdef<A, B>(A? a, B? Function(A)? f) {
  return a != null ? f?.call(a) : null;
}

B? ifok<A, B>(A? a, B? Function()? f) {
  return a != null ? f?.call() : null;
}

T? ifyes<T>(bool? b, T? Function()? f) {
  return b == true ? f?.call() : null;
}

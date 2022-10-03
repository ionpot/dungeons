String bonusText(int i) {
  if (i > 0) return '+$i';
  if (i < 0) return '$i';
  return '';
}

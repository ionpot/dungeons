import "package:dungeons/game/entity/bonus.dart";
import "package:dungeons/widget/colors.dart";

int compareBonus(Bonus a, Bonus b) {
  final aa = ignoreBonusColor(a) ? 1 : 0;
  final bb = ignoreBonusColor(b) ? 1 : 0;
  return aa == bb ? a.text.compareTo(b.text) : bb - aa;
}

import "package:dungeons/game/entity/grid_range.dart";
import "package:dungeons/game/entity/status_effect.dart";

enum Aura {
  torch("Torch", PartyRange.enemy, StatusEffect.slow);

  final String text;
  final PartyRange range;
  final StatusEffect effect;

  const Aura(this.text, this.range, this.effect);
}

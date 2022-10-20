import 'package:dungeons/utility/percent.dart';

enum EffectSource { weapon, armor }

class EffectBonus {
  final int? initiative;
  final Percent? dodgeScale;

  const EffectBonus({
    this.initiative,
    this.dodgeScale,
  });
}

class Effect {
  final EffectSource source;
  final EffectBonus bonus;

  const Effect(this.source, this.bonus);
}

typedef GetEffectBonus<T extends Object> = T? Function(EffectBonus);

class Effects {
  final List<Effect> list = [];

  Effects();

  void add(EffectSource source, EffectBonus bonus) {
    list.add(Effect(source, bonus));
  }

  void remove(EffectSource source) {
    list.removeWhere((e) => e.source == source);
  }

  int sumInt(GetEffectBonus<int> f) {
    int sum = 0;
    for (final effect in list) {
      sum += f(effect.bonus) ?? 0;
    }
    return sum;
  }

  Percent sumPercent(GetEffectBonus<Percent> f) {
    var sum = const Percent();
    for (final effect in list) {
      final s = f(effect.bonus);
      if (s != null) sum += s;
    }
    return sum;
  }
}

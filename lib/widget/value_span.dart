import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/source.dart';
import 'package:dungeons/game/spell.dart';
import 'package:dungeons/game/value.dart';
import 'package:dungeons/utility/dice.dart';
import 'package:dungeons/utility/range.dart';
import 'package:dungeons/widget/colors.dart';
import 'package:flutter/widgets.dart';

class PercentValueSpan extends TextSpan {
  PercentValueSpan(PercentValue value)
      : super(
          text: '$value',
          style: TextStyle(color: percentValueColor(value)),
        );
}

class PercentValueRollSpan extends TextSpan {
  PercentValueRollSpan(PercentValueRoll value)
      : super(
          children: [
            const TextSpan(text: '('),
            PercentValueSpan(value.input),
            TextSpan(text: ') ${value.result}'),
          ],
        );
}

class RangeSpan extends TextSpan {
  RangeSpan(Range range, {bool max = false})
      : super(
          text: '${max ? range.max : range}',
          style: TextStyle(color: max ? green : null),
        );
}

class DiceRollSpan extends TextSpan {
  DiceRollSpan(DiceRoll value) : super(text: '(${value.dice.base}) $value');
}

class DiceValueSpan extends TextSpan {
  DiceValueSpan(DiceValue value)
      : super(
          children: [
            TextSpan(text: '${value.base.base}'),
            TextSpan(
              text: '${value.diceBonuses}',
              style: TextStyle(color: diceBonusesColor(value.diceBonuses)),
            ),
            TextSpan(
              text: value.intBonusString,
              style: TextStyle(color: intBonusesColor(value.intBonuses)),
            ),
          ],
        );
}

class DiceValueWithRangeSpan extends TextSpan {
  DiceValueWithRangeSpan(DiceValue value)
      : super(
          children: [
            const TextSpan(text: '('),
            DiceValueSpan(value),
            const TextSpan(text: ') '),
            RangeSpan(value.range, max: value.max),
          ],
        );
}

class DiceRollValueSpan extends TextSpan {
  DiceRollValueSpan(DiceRollValue value)
      : super(
          text: '${value.total}',
          style: TextStyle(
            color: intColor(value.bonusTotal) ?? (value.max ? green : null),
          ),
        );
}

class DamageSpan extends TextSpan {
  DamageSpan(DiceRollValue damage, Source source)
      : super(
          children: [
            DiceRollValueSpan(damage),
            TextSpan(
              text: ' ${source.name}',
              style: TextStyle(color: sourceColor(source)),
            ),
          ],
        );
}

class HpSpan extends TextSpan {
  HpSpan(Entity entity)
      : super(
          children: [
            TextSpan(
              text: '${entity.hp}',
              style: TextStyle(color: hpColor(entity)),
            ),
            TextSpan(text: '/${entity.totalHp}'),
          ],
        );
}

class StressSpan extends TextSpan {
  StressSpan(Entity entity)
      : super(
          children: [
            TextSpan(text: '${entity.stress}/'),
            StressCapSpan(entity),
          ],
        );
}

class StressCapSpan extends TextSpan {
  StressCapSpan(Entity entity)
      : super(
          text: '${entity.stressCap}',
          style: TextStyle(color: stressCapColor(entity)),
        );
}

class SpellNameSpan extends TextSpan {
  SpellNameSpan(Spell spell)
      : super(
          text: spell.text,
          style: TextStyle(color: sourceColor(spell.source)),
        );
}

import 'package:dungeons/game/entity.dart';
import 'package:dungeons/game/source.dart';
import 'package:dungeons/game/spell.dart';
import 'package:dungeons/game/value.dart';
import 'package:dungeons/utility/bonus_text.dart';
import 'package:dungeons/widget/colors.dart';
import 'package:flutter/widgets.dart';

TextStyle _style(Color? color, {bool bold = false}) {
  return TextStyle(
    color: color,
    fontWeight: bold ? FontWeight.bold : null,
  );
}

class IntSpan extends TextSpan {
  IntSpan(int value, {bool bold = false})
      : super(
          text: '$value',
          style: _style(intColor(value), bold: bold),
        );
}

class IntValueSpan extends TextSpan {
  IntValueSpan(IntValue value, {bool bold = false})
      : super(
          text: '$value',
          style: _style(intValueColor(value), bold: bold),
        );
}

class PercentValueSpan extends TextSpan {
  PercentValueSpan(PercentValue value, {bool bold = false})
      : super(
          text: '$value',
          style: _style(percentValueColor(value), bold: bold),
        );
}

class DiceValueSpan extends TextSpan {
  DiceValueSpan(DiceValue value, {bool bold = false})
      : super(
          children: [
            TextSpan(text: '${value.base}'),
            TextSpan(
              text: bonusText(value.bonus.total),
              style: _style(diceValueColor(value)),
            ),
          ],
          style: _style(null, bold: bold),
        );
}

class DamageSpan extends TextSpan {
  DamageSpan(IntValue damage, Source source, {bool bold = false})
      : super(
          children: [
            IntValueSpan(damage),
            TextSpan(
              text: ' ${source.name}',
              style: _style(sourceColor(source)),
            ),
          ],
          style: _style(null, bold: bold),
        );
}

class StressSpan extends TextSpan {
  StressSpan(Entity entity, {bool bold = false})
      : super(
          children: [
            TextSpan(text: '${entity.stress}/'),
            TextSpan(
              text: '${entity.stressCap}',
              style: _style(stressColor(entity)),
            ),
          ],
          style: _style(null, bold: bold),
        );
}

class SpellNameSpan extends TextSpan {
  SpellNameSpan(Spell spell, {bool bold = false})
      : super(
          text: spell.text,
          style: _style(sourceColor(spell.source), bold: bold),
        );
}

Text toText(TextSpan span) {
  return Text(
    span.text ?? '',
    style: span.style,
  );
}

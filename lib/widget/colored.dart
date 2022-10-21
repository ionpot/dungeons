import 'package:dungeons/game/value.dart';
import 'package:dungeons/widget/colors.dart';
import 'package:flutter/widgets.dart';

class ColoredInt extends StatelessWidget {
  final IntValue value;
  final bool bold;

  const ColoredInt(this.value, {super.key, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      value.total.toString(),
      style: TextStyle(color: _color, fontWeight: _bold),
    );
  }

  Color? get _color {
    switch (value.bonus.sign) {
      case 1:
        return green;
      case -1:
        return red;
      default:
        return null;
    }
  }

  FontWeight? get _bold => bold ? FontWeight.bold : null;
}

class ColoredPercent extends StatelessWidget {
  final PercentValue value;
  final bool bold;

  const ColoredPercent(this.value, {super.key, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      value.total.toString(),
      style: TextStyle(color: _color, fontWeight: _bold),
    );
  }

  Color? get _color {
    switch (value.bonus.sign) {
      case 1:
        return green;
      case -1:
        return red;
      default:
        return null;
    }
  }

  FontWeight? get _bold => bold ? FontWeight.bold : null;
}

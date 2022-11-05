import 'package:dungeons/game/value.dart';
import 'package:dungeons/utility/dice.dart';

enum DamageType { normal, astral, cold }

class Damage {
  final IntValue value;
  final DamageType type;

  const Damage(this.value, [this.type = DamageType.normal]);

  int get total => value.total;

  @override
  String toString() =>
      '$total${type != DamageType.normal ? ' ${type.name}' : ''}';
}

class DamageDice {
  final Dice dice;
  final DamageType type;

  const DamageDice(this.dice, {required this.type});

  Damage roll() => Damage(IntValue.base(dice.roll()), type);

  @override
  String toString() => '$dice';
}

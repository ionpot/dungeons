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

class DamageRoll {
  final DiceRoll dice;
  final DamageType type;

  const DamageRoll(this.dice, this.type);

  Damage get damage => Damage(value, type);
  int get total => dice.total;
  IntValue get value => IntValue(base: dice.total);
}

class DamageDice {
  final Dice dice;
  final DamageType type;

  const DamageDice(this.dice, {required this.type});

  DamageRoll roll() => DamageRoll(dice.roll(), type);

  @override
  String toString() => '$dice';
}

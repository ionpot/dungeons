import 'package:dungeons/utility/dice.dart';
import 'package:dungeons/utility/percent.dart';

enum EntityAttributeId {
  strength(text: 'Strength'),
  agility(text: 'Agility'),
  intellect(text: 'Intellect');

  final String text;

  const EntityAttributeId({required this.text});

  String get short => text.substring(0, 3);

  @override
  String toString() => text;
}

class EntityAttributes {
  int strength;
  int agility;
  int intellect;

  EntityAttributes({
    this.strength = 0,
    this.agility = 0,
    this.intellect = 0,
  });

  factory EntityAttributes.random() => EntityAttributes()..roll();

  EntityAttributes operator +(EntityAttributes? a) {
    if (a == null) return this;
    return EntityAttributes(
      strength: strength + a.strength,
      agility: agility + a.agility,
      intellect: intellect + a.intellect,
    );
  }

  Percent get dodge => Percent(agility);
  Percent get resist => Percent(intellect);
  int get initiative => (agility + intellect) ~/ 2;

  bool isEmpty() => (strength == 0) && (agility == 0) && (intellect == 0);

  int ofId(EntityAttributeId id) {
    switch (id) {
      case EntityAttributeId.strength:
        return strength;
      case EntityAttributeId.agility:
        return agility;
      case EntityAttributeId.intellect:
        return intellect;
    }
  }

  void roll() {
    const dice = Dice(3, 6);
    strength = dice.roll();
    agility = dice.roll();
    intellect = dice.roll();
  }

  @override
  String toString() =>
      EntityAttributeId.values.map((e) => '${e.short} ${ofId(e)}').join(', ');
}

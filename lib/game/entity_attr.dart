import 'package:dungeons/utility/dice.dart';
import 'package:dungeons/utility/has_text.dart';
import 'package:dungeons/utility/percent.dart';

enum EntityAttributeId implements HasText {
  strength(text: 'Strength'),
  agility(text: 'Agility'),
  intellect(text: 'Intellect');

  @override
  final String text;

  const EntityAttributeId({required this.text});
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

  EntityAttributes operator +(EntityAttributes a) {
    return EntityAttributes(
      strength: strength + a.strength,
      agility: agility + a.agility,
      intellect: intellect + a.intellect,
    );
  }

  Percent get dodge => Percent(agility);
  Percent get resist => Percent(intellect);
  int get initiative => (agility ~/ 2) + (intellect ~/ 2);

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
}

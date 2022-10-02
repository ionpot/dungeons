import 'package:dungeons/game/dice.dart';
import 'package:dungeons/utility/has_text.dart';

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

  factory EntityAttributes.random() {
    final e = EntityAttributes();
    e.roll();
    return e;
  }

  bool isEmpty() {
    return (strength == 0) && (agility == 0) && (intellect == 0);
  }

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
    strength = _roll();
    agility = _roll();
    intellect = _roll();
  }

  int _roll() => rollDice(3, 6);
}

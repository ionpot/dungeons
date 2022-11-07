import 'package:dungeons/utility/dice.dart';
import 'package:dungeons/utility/pick_random.dart';

enum EntityAttributeId {
  strength(text: 'Strength'),
  agility(text: 'Agility'),
  intellect(text: 'Intellect');

  static EntityAttributeId random() => pickRandom(EntityAttributeId.values);

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

  void add(EntityAttributeId id) {
    switch (id) {
      case EntityAttributeId.strength:
        ++strength;
        return;
      case EntityAttributeId.agility:
        ++agility;
        return;
      case EntityAttributeId.intellect:
        ++intellect;
        return;
    }
  }

  void roll() {
    int roll() => const Dice(3, 6).roll().total;
    strength = roll();
    agility = roll();
    intellect = roll();
  }

  @override
  String toString() =>
      EntityAttributeId.values.map((e) => '${e.short} ${ofId(e)}').join(', ');
}

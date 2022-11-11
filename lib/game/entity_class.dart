import 'package:dungeons/utility/pick_random.dart';

enum EntityClass {
  warrior(text: 'Warrior', hpBonus: 4),
  trickster(text: 'Trickster', hpBonus: 3),
  cleric(text: 'Cleric', hpBonus: 3),
  mage(text: 'Mage', hpBonus: 2);

  final int hpBonus;
  final String text;

  const EntityClass({required this.text, required this.hpBonus});

  factory EntityClass.random() => pickRandom(EntityClass.values);

  @override
  String toString() => text;
}

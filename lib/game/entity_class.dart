import 'package:dungeons/utility/has_text.dart';
import 'package:dungeons/utility/pick_random.dart';

enum EntityClass implements HasText {
  warrior(text: 'Warrior', hpBonus: 4),
  hybrid(text: 'Hybrid', hpBonus: 3),
  mage(text: 'Mage', hpBonus: 2);

  const EntityClass({required this.text, required this.hpBonus});

  factory EntityClass.random() => pickRandom(EntityClass.values);

  final int hpBonus;

  @override
  final String text;
}

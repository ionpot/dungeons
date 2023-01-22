import 'package:dungeons/game/spell.dart';
import 'package:dungeons/utility/pick_random.dart';

enum EntityClass {
  warrior(text: 'Warrior', hpBonus: 4),
  trickster(text: 'Trickster', hpBonus: 3),
  cleric(text: 'Cleric', hpBonus: 3, spells: {Spell.bless, Spell.heal}),
  mage(
    text: 'Mage',
    hpBonus: 2,
    spells: {Spell.magicMissile, Spell.rayOfFrost},
  );

  final int hpBonus;
  final String text;
  final Set<Spell>? spells;

  const EntityClass({required this.text, required this.hpBonus, this.spells});

  factory EntityClass.random() => pickRandom(EntityClass.values);

  @override
  String toString() => text;
}

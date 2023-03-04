import 'package:dungeons/game/spell.dart';

class SpellBook {
  final Set<Spell> spells;

  const SpellBook(this.spells);

  Set<Spell> spellsForLevel(int level) {
    return {
      for (final spell in spells)
        if (spell.requiresLevel <= level) spell
    };
  }
}

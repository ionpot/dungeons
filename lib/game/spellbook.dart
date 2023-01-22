import 'dart:math';

import 'package:dungeons/game/spell.dart';
import 'package:dungeons/utility/pick_random.dart';

class SpellBook {
  final Set<Spell> spells;

  const SpellBook(this.spells);

  List<Spell> get spellList => spells.toList(growable: false);

  Spell? maybeRandomSpell() => pickRandomMaybe(spellList);
}

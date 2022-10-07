import 'package:dungeons/game/entity_attr.dart';
import 'package:dungeons/utility/has_text.dart';

class EntityRace implements HasText {
  final EntityAttributes bonus;

  const EntityRace(this.text, this.bonus);

  @override
  final String text;
}

final human = EntityRace('Human', EntityAttributes());
final orc = EntityRace('Orc', EntityAttributes(strength: 2, intellect: -2));

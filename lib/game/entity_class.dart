import 'package:dungeons/utility/has_text.dart';

enum EntityClass implements HasText {
  warrior(text: 'Warrior'),
  hybrid(text: 'Hybrid'),
  mage(text: 'Mage');

  const EntityClass({required this.text});

  @override
  final String text;
}

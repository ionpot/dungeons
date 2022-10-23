import 'package:dungeons/game/effect_bonus.dart';
import 'package:dungeons/utility/percent.dart';

enum Skill {
  weaponFocus(
    text: 'Weapon Focus',
    bonus: EffectBonus(hit: Percent(1), damage: 1, reserveStress: 1),
  );

  final String text;
  final EffectBonus bonus;

  const Skill({required this.text, required this.bonus});
}

enum SkillState { active, ready, disabled, unknown }

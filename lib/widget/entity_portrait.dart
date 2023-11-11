import "package:dungeons/game/entity.dart";
import "package:dungeons/game/entity_race.dart";
import "package:dungeons/widget/clickable.dart";
import "package:flutter/widgets.dart";

enum PortraitTargeting {
  friendly,
  enemy,
  cantTarget,
}

class EntityPortrait extends StatelessWidget {
  final Entity entity;
  final bool current;
  final PortraitTargeting? targeting;
  final VoidCallback? onMouseEnter;
  final VoidCallback? onMouseClick;

  const EntityPortrait(
    this.entity, {
    super.key,
    this.current = false,
    this.targeting,
    this.onMouseClick,
    this.onMouseEnter,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        if (onMouseEnter != null) onMouseEnter!();
      },
      child: Clickable(
        state: _clickableState,
        onClick: () {
          if (onMouseClick != null) onMouseClick!();
        },
        child: Stack(
          children: [
            Image.asset("image/portrait_$_name.png"),
            if (current) Image.asset("image/portrait_current.png"),
            if (targeting == PortraitTargeting.friendly)
              Image.asset("image/portrait_target_friendly.png"),
            if (targeting == PortraitTargeting.enemy)
              Image.asset("image/portrait_target_enemy.png"),
          ],
        ),
      ),
    );
  }

  ClickableState get _clickableState {
    if (entity.dead) {
      return ClickableState.disabled;
    }
    if (targeting == null || onMouseClick == null) {
      return ClickableState.active;
    }
    if (targeting == PortraitTargeting.cantTarget) {
      return ClickableState.disabled;
    }
    return ClickableState.enabled;
  }

  String get _name {
    if (entity.race == EntityRace.orc) {
      return "orc";
    }
    return entity.klass.toString().toLowerCase();
  }
}

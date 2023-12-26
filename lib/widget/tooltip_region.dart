import "package:dungeons/widget/screen_overlay.dart";
import "package:flutter/widgets.dart";

class TooltipRegion extends StatelessWidget {
  final Widget child;
  final Widget tooltip;
  final bool disabled;

  const TooltipRegion({
    super.key,
    required this.child,
    required this.tooltip,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    if (disabled) {
      return child;
    }
    final overlay = ScreenOverlay.of(context)?.tooltip;
    return MouseRegion(
      onEnter: (event) => overlay?.show(tooltip, event.position),
      onExit: (event) => overlay?.hide(),
      onHover: (event) => overlay?.position(event.position),
      child: child,
    );
  }
}

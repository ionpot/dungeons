import 'package:dungeons/widget/screen_overlay.dart';
import 'package:flutter/widgets.dart';

class TooltipRegion extends StatelessWidget {
  final Widget child;
  final Widget tooltip;

  const TooltipRegion({super.key, required this.tooltip, required this.child});

  @override
  Widget build(BuildContext context) {
    final overlay = ScreenOverlay.of(context)?.tooltip;
    return MouseRegion(
      onEnter: (event) => overlay?.show(tooltip, event.position),
      onExit: (event) => overlay?.hide(),
      onHover: (event) => overlay?.position(event.position),
      child: child,
    );
  }
}

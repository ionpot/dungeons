import 'package:dungeons/widget/screen_overlay.dart';
import 'package:flutter/widgets.dart';

class TooltipRegion extends StatelessWidget {
  final Widget child;
  final Widget content;

  const TooltipRegion({super.key, required this.content, required this.child});

  @override
  Widget build(BuildContext context) {
    final tooltip = ScreenOverlay.of(context)?.tooltip;
    return MouseRegion(
      onEnter: (event) => tooltip?.show(content, event.position),
      onExit: (event) => tooltip?.hide(),
      onHover: (event) => tooltip?.position(event.position),
      child: child,
    );
  }
}

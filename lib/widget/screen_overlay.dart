import "package:dungeons/widget/tooltip.dart";
import "package:flutter/widgets.dart";

class ScreenOverlay extends StatelessWidget {
  final Widget child;
  final Tooltip tooltip = Tooltip();

  ScreenOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ScreenOverlayData(tooltip: tooltip, child: child),
        TooltipWidget(tooltip),
      ],
    );
  }

  static ScreenOverlayData? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ScreenOverlayData>();
  }
}

class ScreenOverlayData extends InheritedWidget {
  final Tooltip tooltip;

  const ScreenOverlayData({
    super.key,
    required super.child,
    required this.tooltip,
  });

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}

import 'dart:math';

import 'package:dungeons/widget/colors.dart';
import 'package:dungeons/widget/empty.dart';
import 'package:flutter/widgets.dart';

class Tooltip {
  final contentNotifier = ValueNotifier<Widget?>(null);
  final offsetNotifier = ValueNotifier<Offset>(const Offset(0, 0));

  Tooltip();

  void show(Widget content, Offset offset) {
    contentNotifier.value = content;
    position(offset);
  }

  void hide() {
    contentNotifier.value = null;
  }

  void position(Offset offset) {
    offsetNotifier.value = offset;
  }
}

class TooltipWidget extends StatefulWidget {
  final Tooltip tooltip;

  const TooltipWidget(this.tooltip, {super.key});

  @override
  State<StatefulWidget> createState() => _TooltipWidgetState();
}

class _TooltipWidgetState extends State<TooltipWidget> {
  Widget? content;

  ValueNotifier<Widget?> get contentNotifier => widget.tooltip.contentNotifier;

  void onContentChange() {
    setState(() {
      content = contentNotifier.value;
    });
  }

  @override
  void initState() {
    super.initState();
    contentNotifier.addListener(onContentChange);
  }

  @override
  void didUpdateWidget(TooltipWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.tooltip.contentNotifier.removeListener(onContentChange);
    contentNotifier.addListener(onContentChange);
  }

  @override
  void dispose() {
    contentNotifier.removeListener(onContentChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (content == null) {
      return const Empty();
    }
    return CustomSingleChildLayout(
      delegate: TooltipOffsetDelegate(widget.tooltip.offsetNotifier),
      child: _wrapper(content!),
    );
  }

  Widget _wrapper(Widget child) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: gold),
        borderRadius: BorderRadius.circular(2),
        color: black,
      ),
      child: child,
    );
  }
}

class TooltipOffsetDelegate extends SingleChildLayoutDelegate {
  final ValueNotifier<Offset> offset;

  const TooltipOffsetDelegate(this.offset) : super(relayout: offset);

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    const base = Offset(20, 0);
    final content = Size(
      base.dx + childSize.width,
      base.dy + childSize.height,
    );
    final o = offset.value;
    final w = o.dx + content.width;
    final dw = (w - size.width > 0) ? content.width : -base.dx;
    final h = o.dy + content.height;
    final dh = max(0, h - size.height);
    return Offset(o.dx - dw, o.dy - dh);
  }

  @override
  bool shouldRelayout(TooltipOffsetDelegate oldDelegate) {
    return offset.value != oldDelegate.offset.value;
  }
}

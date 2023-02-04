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
  void didUpdateWidget(covariant TooltipWidget oldWidget) {
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
    return ValueListenableBuilder<Offset>(
      valueListenable: widget.tooltip.offsetNotifier,
      builder: (BuildContext context, Offset offset, Widget? child) {
        return Positioned(
          left: offset.dx - 40,
          top: offset.dy + 20,
          child: child!,
        );
      },
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

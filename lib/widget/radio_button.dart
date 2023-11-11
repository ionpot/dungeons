import "package:dungeons/widget/button.dart";
import "package:dungeons/widget/clickable.dart";
import "package:flutter/widgets.dart";

class RadioButton extends StatelessWidget {
  final String text;
  final bool chosen;
  final bool enabled;
  final VoidCallback onChosen;

  const RadioButton({
    super.key,
    required this.text,
    required this.chosen,
    required this.onChosen,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Button(
      text: text,
      state: _state,
      onClick: () {
        if (!chosen) onChosen();
      },
    );
  }

  ClickableState get _state {
    if (chosen) {
      return ClickableState.active;
    }
    return enabled ? ClickableState.enabled : ClickableState.disabled;
  }
}

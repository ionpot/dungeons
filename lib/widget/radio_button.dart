import 'package:dungeons/widget/button.dart';
import 'package:flutter/widgets.dart';

typedef RadioValue = Object;

class RadioButton<T extends RadioValue> extends StatelessWidget {
  final T value;
  final bool chosen;
  final ValueChanged<T> onChosen;

  const RadioButton({
    super.key,
    required this.value,
    required this.chosen,
    required this.onChosen,
  });

  @override
  Widget build(BuildContext context) {
    return Button(
      '$value',
      active: chosen,
      clickable: !chosen,
      onClick: () => {if (!chosen) onChosen(value)},
    );
  }
}

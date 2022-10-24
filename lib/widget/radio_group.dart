import 'package:dungeons/widget/radio_button.dart';
import 'package:dungeons/widget/spaced.dart';
import 'package:flutter/widgets.dart';

class RadioGroup<T extends RadioValue> extends StatefulWidget {
  final List<T> values;
  final ValueChanged<T> onChange;

  const RadioGroup({super.key, required this.values, required this.onChange});

  @override
  State<RadioGroup<T>> createState() => _RadioGroupState();
}

class _RadioGroupState<T extends RadioValue> extends State<RadioGroup<T>> {
  T? chosen;

  @override
  Widget build(BuildContext context) {
    return buildSpacedRow(
      spacing: 10,
      children: List<Widget>.from(
        widget.values.map(
          (e) => _buildButton(e),
        ),
      ),
    );
  }

  Widget _buildButton(T value) {
    return RadioButton<T>(
      value: value,
      chosen: value == chosen,
      onChosen: (newValue) {
        setState(() => chosen = newValue);
        widget.onChange(newValue);
      },
    );
  }
}

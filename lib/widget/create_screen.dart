import 'package:dungeons/widget/button.dart';
import 'package:dungeons/widget/section.dart';
import 'package:flutter/widgets.dart';

class CreateScreen extends StatelessWidget {
  final VoidCallback onDone;

  const CreateScreen({super.key, required this.onDone});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Section.below(child: Text('Create character')),
        Section.below(child: Button(text: 'Done', onClick: onDone)),
      ],
    );
  }
}

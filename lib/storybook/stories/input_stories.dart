import 'package:flutter/material.dart';
import '../../core/theme/app_spacing.dart';
import '../widgets/story_section.dart';

class InputStories extends StatelessWidget {
  const InputStories({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(AppSpacing.xl),
      children: [
        const Text('Inputs', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        const SizedBox(height: AppSpacing.base),
        const Text('Text fields, dropdowns, and switch inputs.'),
        const SizedBox(height: AppSpacing.xl),

        const StorySection(
          title: 'Text Field',
          description: 'Standard text input.',
          children: [
            Text('(Implement AppTextField)'),
          ],
        ),
      ],
    );
  }
}

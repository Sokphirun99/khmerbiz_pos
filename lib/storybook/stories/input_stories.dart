import 'package:flutter/material.dart';
import 'package:khmerbiz_pos/core/theme/app_spacing.dart';
import 'package:khmerbiz_pos/storybook/widgets/story_section.dart';

class InputStories extends StatelessWidget {
  const InputStories({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      children: const [
        Text('Inputs', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        SizedBox(height: AppSpacing.base),
        Text('Text fields, dropdowns, and switch inputs.'),
        SizedBox(height: AppSpacing.xl),

        StorySection(
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

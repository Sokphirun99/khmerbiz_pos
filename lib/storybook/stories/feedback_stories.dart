import 'package:flutter/material.dart';
import 'package:khmerbiz_pos/core/theme/app_spacing.dart';
import 'package:khmerbiz_pos/storybook/widgets/story_section.dart';

class FeedbackStories extends StatelessWidget {
  const FeedbackStories({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      children: [
        const Text('Feedback', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        const SizedBox(height: AppSpacing.base),
        const Text('Toasts, Snackbars, and dialogs.'),
        const SizedBox(height: AppSpacing.xl),

        StorySection(
          title: 'App Toast',
          description: 'Temporary floating feedback.',
          children: [
            ElevatedButton(
              onPressed: () {},
              child: const Text('Show Success Toast'),
            ),
          ],
        ),
      ],
    );
  }
}

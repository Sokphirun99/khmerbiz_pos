import 'package:flutter/material.dart';
import '../../core/theme/app_spacing.dart';
import '../widgets/story_section.dart';

class EmptyLoadingStories extends StatelessWidget {
  const EmptyLoadingStories({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(AppSpacing.xl),
      children: [
        const Text('Empty & Loading', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        const SizedBox(height: AppSpacing.base),
        const Text('States for empty data or loading screens.'),
        const SizedBox(height: AppSpacing.xl),

        const StorySection(
          title: 'Empty State',
          description: 'Used when lists or screens have no data.',
          children: [
            Text('(Implement AppEmptyState)'),
          ],
        ),
      ],
    );
  }
}

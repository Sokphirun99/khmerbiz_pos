import 'package:flutter/material.dart';
import 'package:khmerbiz_pos/core/theme/app_spacing.dart';
import 'package:khmerbiz_pos/storybook/widgets/story_section.dart';

/// A story collection for empty and loading state components.
class EmptyLoadingStories extends StatelessWidget {
  /// Creates an [EmptyLoadingStories].
  const EmptyLoadingStories({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      children: const [
        Text('Empty & Loading',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),),
        SizedBox(height: AppSpacing.base),
        Text('States for empty data or loading screens.'),
        SizedBox(height: AppSpacing.xl),
        StorySection(
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

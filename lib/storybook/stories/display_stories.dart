import 'package:flutter/material.dart';
import 'package:khmerbiz_pos/core/theme/app_spacing.dart';
import 'package:khmerbiz_pos/storybook/widgets/story_section.dart';

/// A story collection for display components.
class DisplayStories extends StatelessWidget {
  /// Creates a [DisplayStories].
  const DisplayStories({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      children: const [
        Text('Displays',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),),
        SizedBox(height: AppSpacing.base),
        Text('Data display components like badges, avatars, generic stats.'),
        SizedBox(height: AppSpacing.xl),
        StorySection(
          title: 'App Badge',
          description: 'Used for cart count or notifications.',
          children: [
            Text('(Implement AppBadge)'),
          ],
        ),
      ],
    );
  }
}

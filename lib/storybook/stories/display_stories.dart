import 'package:flutter/material.dart';
import '../../core/theme/app_spacing.dart';
import '../widgets/story_section.dart';

class DisplayStories extends StatelessWidget {
  const DisplayStories({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(AppSpacing.xl),
      children: [
        const Text('Displays', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        const SizedBox(height: AppSpacing.base),
        const Text('Data display components like badges, avatars, generic stats.'),
        const SizedBox(height: AppSpacing.xl),

        const StorySection(
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

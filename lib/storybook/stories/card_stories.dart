import 'package:flutter/material.dart';
import 'package:khmerbiz_pos/core/theme/app_spacing.dart';
import 'package:khmerbiz_pos/storybook/widgets/story_section.dart';

class CardStories extends StatelessWidget {
  const CardStories({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      children: const [
        Text('Cards', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        SizedBox(height: AppSpacing.base),
        Text('Product, Dashboard, and generic cards.'),
        SizedBox(height: AppSpacing.xl),

        StorySection(
          title: 'Product Card',
          description: 'A standard product card for grid view.',
          children: [
            Text('(Implement ProductCard)'),
          ],
        ),
      ],
    );
  }
}

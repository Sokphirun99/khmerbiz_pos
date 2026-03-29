import 'package:flutter/material.dart';
import '../../core/theme/app_spacing.dart';
import '../widgets/story_section.dart';

class CardStories extends StatelessWidget {
  const CardStories({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(AppSpacing.xl),
      children: [
        const Text('Cards', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        const SizedBox(height: AppSpacing.base),
        const Text('Product, Dashboard, and generic cards.'),
        const SizedBox(height: AppSpacing.xl),

        const StorySection(
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

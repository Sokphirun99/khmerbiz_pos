import 'package:flutter/material.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/buttons/app_button.dart';
import '../widgets/story_section.dart';

class ButtonStories extends StatelessWidget {
  const ButtonStories({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(AppSpacing.xl),
      children: [
        const Text('Buttons', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        const SizedBox(height: AppSpacing.base),
        const Text('AppButton variants, states, and sizes.'),
        const SizedBox(height: AppSpacing.xl),

        StorySection(
          title: 'Primary Button',
          description: 'Used for main CTAs (e.g. Checkout, Pay).',
          children: [
            AppButton(
              label: 'Primary Default',
              onTap: () {},
            ),
            AppButton(
              label: 'Primary with Icon',
              icon: Icons.shopping_cart,
              onTap: () {},
            ),
            AppButton(
              label: 'Primary Loading',
              isLoading: true,
              onTap: () {},
            ),
            AppButton(
              label: 'Primary Disabled',
              isDisabled: true,
              onTap: () {},
            ),
          ],
        ),

        StorySection(
          title: 'Secondary Button',
          description: 'Used for secondary actions (e.g. Save, Add Note).',
          children: [
            AppButton(
              label: 'Secondary Default',
              type: AppButtonType.secondary,
              onTap: () {},
            ),
            AppButton(
              label: 'Secondary Disabled',
              type: AppButtonType.secondary,
              isDisabled: true,
              onTap: () {},
            ),
          ],
        ),

        StorySection(
          title: 'Ghost & Danger Buttons',
          description: 'Ghost for Back/Cancel. Danger for destructive actions.',
          children: [
            AppButton(
              label: 'Ghost Button',
              type: AppButtonType.ghost,
              onTap: () {},
            ),
            AppButton(
              label: 'Danger Button',
              type: AppButtonType.danger,
              onTap: () {},
            ),
            AppButton(
              label: 'Accent Button',
              type: AppButtonType.accent,
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}

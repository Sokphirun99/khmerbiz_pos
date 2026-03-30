import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:khmerbiz_pos/core/theme/app_colors.dart';
import 'package:khmerbiz_pos/core/theme/app_spacing.dart';
import 'package:khmerbiz_pos/core/theme/app_text_styles.dart';
import 'package:khmerbiz_pos/storybook/widgets/story_section.dart';

class FoundationStories extends StatelessWidget {
  const FoundationStories({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      children: [
        const Text('Foundation', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        const SizedBox(height: AppSpacing.base),
        const Text('Core design tokens including Colors, Spacing, and Typography.'),
        const SizedBox(height: AppSpacing.xl),

        const StorySection(
          title: 'Brand Colors',
          description: 'Primary and accent brand colors.',
          children: [
            _ColorSwatch('Primary', AppColors.primary),
            _ColorSwatch('Primary Light', AppColors.primaryLight),
            _ColorSwatch('Primary Dark', AppColors.primaryDark),
            _ColorSwatch('Accent', AppColors.accent),
            _ColorSwatch('Accent Light', AppColors.accentLight),
            _ColorSwatch('Accent Dark', AppColors.accentDark),
          ],
        ),

        const StorySection(
          title: 'Semantic Colors',
          description: 'State colors for success, warning, error, info.',
          children: [
            _ColorSwatch('Success', AppColors.success),
            _ColorSwatch('Warning', AppColors.warning),
            _ColorSwatch('Error', AppColors.error),
            _ColorSwatch('Info', AppColors.info),
          ],
        ),

        const StorySection(
          title: 'Background & Surface',
          children: [
            _ColorSwatch('Background', AppColors.background),
            _ColorSwatch('Surface', AppColors.surface),
            _ColorSwatch('Surface Alt', AppColors.surfaceAlt),
          ],
        ),

        const StorySection(
          title: 'Text Colors',
          children: [
            _ColorSwatch('Text Primary', AppColors.textPrimary),
            _ColorSwatch('Text Secondary', AppColors.textSecondary),
            _ColorSwatch('Text Hint', AppColors.textHint),
            _ColorSwatch('Text Disabled', AppColors.textDisabled),
          ],
        ),

        StorySection(
          title: 'Typography (Headlines)',
          children: [
            Text('Headline Large', style: AppTextStyles.headlineLarge),
            Text('Headline Medium', style: AppTextStyles.headlineMedium),
            Text('Headline Small', style: AppTextStyles.headlineSmall),
          ],
        ),

        StorySection(
          title: 'Typography (Body)',
          children: [
            Text('Body Large - For primary content', style: AppTextStyles.bodyLarge),
            Text('Body Medium - For secondary info', style: AppTextStyles.bodyMedium),
            Text('Body Small - For labels and hints', style: AppTextStyles.bodySmall),
          ],
        ),
      ],
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch(this.label, this.color);
  
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.borderLight, width: 2),
            boxShadow: const [
              BoxShadow(color: AppColors.shadow, blurRadius: 4, offset: Offset(0, 2)),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          width: 80,
          child: Text(
            label, 
            style: AppTextStyles.bodySmall, 
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('label', label));
    properties.add(ColorProperty('color', color));
  }
}

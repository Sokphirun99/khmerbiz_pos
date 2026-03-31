import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:khmerbiz_pos/core/theme/app_colors.dart';
import 'package:khmerbiz_pos/core/theme/app_spacing.dart';
import 'package:khmerbiz_pos/core/theme/app_text_styles.dart';
import 'package:khmerbiz_pos/core/theme/foundation/app_radius.dart';

/// A widget that represents a section in the storybook.
///
/// Groups related component variants together with a title and description.
class StorySection extends StatelessWidget {
  /// Creates a [StorySection].
  const StorySection({
    required this.title,
    required this.children,
    super.key,
    this.description,
  });

  /// The title of the section.
  final String title;

  /// An optional description for the section.
  final String? description;

  /// The list of widget variants to display.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.headlineMedium),
          if (description != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(description!,
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.textSecondary),),
          ],
          const SizedBox(height: AppSpacing.base),
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Wrap(
              spacing: AppSpacing.lg,
              runSpacing: AppSpacing.lg,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
    properties.add(StringProperty('description', description));
  }
}

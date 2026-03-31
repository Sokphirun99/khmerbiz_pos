import 'package:flutter/material.dart';
import 'package:khmerbiz_pos/core/theme/app_spacing.dart';
import 'package:khmerbiz_pos/shared/widgets/displays/khqr_display_widget.dart';
import 'package:khmerbiz_pos/storybook/widgets/story_section.dart';

/// A story collection for KHQR display components.
class KhqrStories extends StatelessWidget {
  /// Creates a [KhqrStories].
  const KhqrStories({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      children: const [
        Text('KHQR',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),),
        SizedBox(height: AppSpacing.base),
        Text('Dynamic KHQR payment displays.'),
        SizedBox(height: AppSpacing.xl),
        StorySection(
          title: 'Generating State',
          children: [KhqrDisplayWidget(state: KhqrState.generating)],
        ),
        StorySection(
          title: 'Ready State',
          children: [KhqrDisplayWidget(state: KhqrState.ready)],
        ),
      ],
    );
  }
}

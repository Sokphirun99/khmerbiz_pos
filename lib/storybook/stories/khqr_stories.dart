import 'package:flutter/material.dart';
import '../../core/theme/app_spacing.dart';
import '../widgets/story_section.dart';
import '../../shared/widgets/displays/khqr_display_widget.dart';

class KhqrStories extends StatelessWidget {
  const KhqrStories({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(AppSpacing.xl),
      children: [
        const Text('KHQR', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        const SizedBox(height: AppSpacing.base),
        const Text('Dynamic KHQR payment displays.'),
        const SizedBox(height: AppSpacing.xl),

        const StorySection(
          title: 'Generating State',
          children: [KhqrDisplayWidget(state: KhqrState.generating)],
        ),
        
        const StorySection(
          title: 'Ready State',
          children: [KhqrDisplayWidget(state: KhqrState.ready)],
        ),
      ],
    );
  }
}

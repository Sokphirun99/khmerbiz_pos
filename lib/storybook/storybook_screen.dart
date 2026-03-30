import 'package:flutter/material.dart';
import 'package:khmerbiz_pos/core/theme/app_colors.dart';
import 'package:khmerbiz_pos/core/theme/app_text_styles.dart';
import 'package:khmerbiz_pos/storybook/stories/button_stories.dart';
import 'package:khmerbiz_pos/storybook/stories/card_stories.dart';
import 'package:khmerbiz_pos/storybook/stories/display_stories.dart';
import 'package:khmerbiz_pos/storybook/stories/empty_loading_stories.dart';
import 'package:khmerbiz_pos/storybook/stories/feedback_stories.dart';
import 'package:khmerbiz_pos/storybook/stories/foundation_stories.dart';
import 'package:khmerbiz_pos/storybook/stories/input_stories.dart';
import 'package:khmerbiz_pos/storybook/stories/khqr_stories.dart';

enum StoryLayer {
  foundation('Foundation'),
  buttons('Buttons'),
  cards('Cards'),
  inputs('Inputs'),
  displays('Displays'),
  feedbacks('Feedback'),
  emptyLoading('Empty/Loading'),
  khqr('KHQR');

  const StoryLayer(this.label);
  final String label;
}

class StorybookScreen extends StatefulWidget {
  const StorybookScreen({super.key});

  @override
  State<StorybookScreen> createState() => _StorybookScreenState();
}

class _StorybookScreenState extends State<StorybookScreen> {
  StoryLayer _selectedLayer = StoryLayer.foundation;

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('LDSG Storybook',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
      ),
      drawer: isDesktop ? null : Drawer(child: _buildSidebar()),
      body: Row(
        children: [
          if (isDesktop)
            Container(
              width: 250,
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(right: BorderSide(color: AppColors.border)),
              ),
              child: _buildSidebar(),
            ),
          Expanded(
            child: ColoredBox(
              color: AppColors.background,
              child: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        if (MediaQuery.of(context).size.width <= 600)
          DrawerHeader(
            decoration: const BoxDecoration(color: AppColors.primary),
            child: Text(
              'LDSG Storybook',
              style: AppTextStyles.headlineMedium
                  .copyWith(color: AppColors.onPrimary),
            ),
          ),
        ...StoryLayer.values.map(
          (layer) => ListTile(
            title: Text(
              layer.label,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: _selectedLayer == layer
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: _selectedLayer == layer
                    ? AppColors.primary
                    : AppColors.textPrimary,
              ),
            ),
            selected: _selectedLayer == layer,
            selectedTileColor: AppColors.primaryLight.withValues(alpha: 0.1),
            onTap: () {
              setState(() => _selectedLayer = layer);
              if (MediaQuery.of(context).size.width <= 600) {
                Navigator.pop(context); // Close drawer
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    switch (_selectedLayer) {
      case StoryLayer.foundation:
        return const FoundationStories();
      case StoryLayer.buttons:
        return const ButtonStories();
      case StoryLayer.cards:
        return const CardStories();
      case StoryLayer.inputs:
        return const InputStories();
      case StoryLayer.displays:
        return const DisplayStories();
      case StoryLayer.feedbacks:
        return const FeedbackStories();
      case StoryLayer.emptyLoading:
        return const EmptyLoadingStories();
      case StoryLayer.khqr:
        return const KhqrStories();
    }
  }
}

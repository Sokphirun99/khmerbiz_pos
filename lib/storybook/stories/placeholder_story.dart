import 'package:flutter/material.dart';

import '../../core/theme/app_text_styles.dart';

class PlaceholderStory extends StatelessWidget {
  const PlaceholderStory({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$title Stories\n(Coming soon - Needs implementation)',
        style: AppTextStyles.headlineMedium,
        textAlign: TextAlign.center,
      ),
    );
  }
}

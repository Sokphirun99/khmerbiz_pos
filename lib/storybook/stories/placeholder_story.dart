import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:khmerbiz_pos/core/theme/app_text_styles.dart';

/// A placeholder story for components that are not yet implemented.
class PlaceholderStory extends StatelessWidget {
  /// Creates a [PlaceholderStory].
  const PlaceholderStory({required this.title, super.key});

  /// The title of the story to display.
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
  }
}

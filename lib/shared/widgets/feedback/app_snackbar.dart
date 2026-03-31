import 'package:flutter/material.dart';
import 'package:khmerbiz_pos/core/theme/app_colors.dart';

import 'package:khmerbiz_pos/core/theme/app_text_styles.dart';

/// A utility class for displaying standard snackbars in the application.
class AppSnackbar {
  /// Shows a snackbar with the given [message].
  ///
  /// If [isError] is true, the snackbar will use the error background color.
  /// An optional [actionLabel] and [onAction] can be provided to show an action button.
  static void show(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.surface),
        ),
        backgroundColor: isError ? AppColors.error : AppColors.textPrimary,
        behavior: SnackBarBehavior.fixed,
        action: actionLabel != null && onAction != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: AppColors.primaryLight,
                onPressed: onAction,
              )
            : null,
      ),
    );
  }
}

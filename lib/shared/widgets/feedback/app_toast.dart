import 'package:flutter/material.dart';
import 'package:khmerbiz_pos/core/theme/app_colors.dart';
import 'package:khmerbiz_pos/core/theme/app_spacing.dart';
import 'package:khmerbiz_pos/core/theme/app_text_styles.dart';
import 'package:khmerbiz_pos/core/theme/foundation/app_radius.dart';

class AppToast {
  static void show(
    BuildContext context, {
    required String message,
    bool isError = false,
  }) {
    // In a real implementation this might use Overlay or fluttertoast package.
    // For now we'll simulate a toast using a floating SnackBar with specific styling.
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: AppColors.surface,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                message,
                style:
                    AppTextStyles.bodyMedium.copyWith(color: AppColors.surface),
              ),
            ),
          ],
        ),
        backgroundColor: isError ? AppColors.error : AppColors.textPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(AppSpacing.md),
        elevation: 8,
      ),
    );
  }
}

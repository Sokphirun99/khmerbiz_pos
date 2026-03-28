import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:khmerbiz_pos/core/theme/app_colors.dart';
import 'package:khmerbiz_pos/core/theme/app_spacing.dart';

/// Sync status
enum SyncStatus {
  /// Synced with server
  synced,

  /// Pending sync (has unsynced data)
  pending,

  /// Sync error
  error,

  /// Offline mode
  offline,
}

/// KhmerBiz POS Sync Status Badge
///
/// Mini widget for AppBar showing cloud sync status.
///
/// Features:
/// - Cloud icon with color coding
/// - Pending count badge
/// - Tooltip with status details
/// - Compact size for AppBar
///
/// Usage:
/// ```dart
/// // In AppBar actions
/// AppBar(
///   actions: [
///     SyncStatusBadge(
///       status: SyncStatus.pending,
///       pendingCount: 5,
///       onTap: () => _showSyncDetails(),
///     ),
///   ],
/// )
/// ```
class SyncStatusBadge extends StatelessWidget {

  const SyncStatusBadge({
    super.key,
    this.status = SyncStatus.synced,
    this.pendingCount = 0,
    this.onTap,
    this.showTooltip = true,
    this.tooltipMessage,
  });
  /// Current sync status
  final SyncStatus status;

  /// Number of pending items to sync
  final int pendingCount;

  /// Callback when badge is tapped
  final VoidCallback? onTap;

  /// Show tooltip on long press
  final bool showTooltip;

  /// Custom tooltip message
  final String? tooltipMessage;

  @override
  Widget build(BuildContext context) {
    final (icon, color, semanticLabel) = _getStatusConfig();

    final badge = GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xs),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(
              icon,
              size: 24,
              color: color,
            ),
            // Pending count badge
            if (status == SyncStatus.pending && pendingCount > 0)
              Positioned(
                right: -4,
                top: -4,
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                    border: Border.all(
                      color: AppColors.surface,
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    pendingCount > 99 ? '99+' : '$pendingCount',
                    style: const TextStyle(
                      fontFamily: 'Roboto Mono',
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );

    if (showTooltip) {
      return Tooltip(
        message: tooltipMessage ?? _getDefaultTooltipMessage(),
        child: badge,
      );
    }

    return badge;
  }

  String _getDefaultTooltipMessage() {
    switch (status) {
      case SyncStatus.synced:
        return 'All data synced';
      case SyncStatus.pending:
        return pendingCount > 0
            ? '$pendingCount items pending sync'
            : 'Pending sync';
      case SyncStatus.error:
        return 'Sync error - tap to retry';
      case SyncStatus.offline:
        return 'Offline mode - changes will sync when online';
    }
  }

  (IconData, Color, String) _getStatusConfig() {
    switch (status) {
      case SyncStatus.synced:
        return (
          Icons.cloud_done,
          AppColors.success,
          'Synced',
        );
      case SyncStatus.pending:
        return (
          Icons.cloud_upload,
          AppColors.warning,
          'Pending',
        );
      case SyncStatus.error:
        return (
          Icons.cloud_off,
          AppColors.error,
          'Error',
        );
      case SyncStatus.offline:
        return (
          Icons.cloud_off,
          AppColors.textHint,
          'Offline',
        );
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<SyncStatus>('status', status));
    properties.add(IntProperty('pendingCount', pendingCount));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap));
    properties.add(DiagnosticsProperty<bool>('showTooltip', showTooltip));
    properties.add(StringProperty('tooltipMessage', tooltipMessage));
  }
}

/// Animated sync indicator for sync-in-progress
class SyncProgressIndicator extends StatelessWidget {

  const SyncProgressIndicator({
    super.key,
    this.message,
  });
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              AppColors.primary,
            ),
          ),
        ),
        if (message != null) ...[
          const SizedBox(width: AppSpacing.sm),
          Text(
            message!,
            style: const TextStyle(
              fontFamily: 'Kantumruy Pro',
              fontSize: 13,
              fontWeight: FontWeight.normal,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('message', message));
  }
}

/// Sync status with detailed information
class SyncStatusDetail extends StatelessWidget {

  const SyncStatusDetail({
    super.key,
    required this.status,
    this.pendingCount = 0,
    this.lastSyncTime,
    this.errorMessage,
    this.onRetry,
  });
  final SyncStatus status;
  final int pendingCount;
  final DateTime? lastSyncTime;
  final String? errorMessage;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(
          color: _getBorderColor(),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(_getIcon(), color: _getColor(), size: 24),
              const SizedBox(width: AppSpacing.sm),
              Text(
                _getTitle(),
                style: const TextStyle(
                  fontFamily: 'Kantumruy Pro',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (lastSyncTime != null) ...[
            Text(
              'Last synced: ${_formatLastSync(lastSyncTime!)}',
              style: const TextStyle(
                fontFamily: 'Kantumruy Pro',
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
          if (status == SyncStatus.pending) ...[
            Text(
              '$pendingCount items waiting to sync',
              style: const TextStyle(
                fontFamily: 'Kantumruy Pro',
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
          if (status == SyncStatus.error && errorMessage != null) ...[
            Text(
              errorMessage!,
              style: const TextStyle(
                fontFamily: 'Kantumruy Pro',
                fontSize: 12,
                color: AppColors.error,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.sm),
              TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Retry'),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 32),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (status) {
      case SyncStatus.synced:
        return AppColors.successLight;
      case SyncStatus.pending:
        return AppColors.warningLight;
      case SyncStatus.error:
        return AppColors.errorLight;
      case SyncStatus.offline:
        return AppColors.surfaceAlt;
    }
  }

  Color _getBorderColor() {
    switch (status) {
      case SyncStatus.synced:
        return AppColors.success.withOpacity(0.3);
      case SyncStatus.pending:
        return AppColors.warning.withOpacity(0.3);
      case SyncStatus.error:
        return AppColors.error.withOpacity(0.3);
      case SyncStatus.offline:
        return AppColors.border;
    }
  }

  IconData _getIcon() {
    switch (status) {
      case SyncStatus.synced:
        return Icons.cloud_done;
      case SyncStatus.pending:
        return Icons.cloud_upload;
      case SyncStatus.error:
        return Icons.cloud_off;
      case SyncStatus.offline:
        return Icons.cloud_off;
    }
  }

  Color _getColor() {
    switch (status) {
      case SyncStatus.synced:
        return AppColors.success;
      case SyncStatus.pending:
        return AppColors.warning;
      case SyncStatus.error:
        return AppColors.error;
      case SyncStatus.offline:
        return AppColors.textHint;
    }
  }

  String _getTitle() {
    switch (status) {
      case SyncStatus.synced:
        return 'Synced';
      case SyncStatus.pending:
        return 'Pending Sync';
      case SyncStatus.error:
        return 'Sync Error';
      case SyncStatus.offline:
        return 'Offline';
    }
  }

  String _formatLastSync(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${time.day}/${time.month} ${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<SyncStatus>('status', status));
    properties.add(IntProperty('pendingCount', pendingCount));
    properties.add(DiagnosticsProperty<DateTime?>('lastSyncTime', lastSyncTime));
    properties.add(StringProperty('errorMessage', errorMessage));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onRetry', onRetry));
  }
}

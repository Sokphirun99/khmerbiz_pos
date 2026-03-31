import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khmerbiz_pos/core/theme/app_colors.dart';
import 'package:khmerbiz_pos/core/theme/app_spacing.dart';
import 'package:khmerbiz_pos/core/theme/app_text_styles.dart';
import 'package:khmerbiz_pos/features/sync/presentation/bloc/sync_bloc.dart';
import 'package:khmerbiz_pos/features/sync/presentation/bloc/sync_event.dart';
import 'package:khmerbiz_pos/features/sync/presentation/bloc/sync_state.dart';

/// Offline banner that slides down when connectivity is lost.
///
/// Shows pending sync count and provides tap-to-view-details functionality.
class OfflineBanner extends StatelessWidget {
  /// Creates an [OfflineBanner].
  const OfflineBanner({
    super.key,
    this.onTap,
  });

  /// Callback when banner is tapped.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SyncBloc, SyncState>(
      builder: (context, state) {
        // Only show when offline or has pending items
        final isOffline = state is Offline;
        final isIdleWithPending = state is SyncIdle && state.pendingCount > 0;
        final isInProgress = state is SyncInProgress;

        if (!isOffline && !isIdleWithPending && !isInProgress) {
          return const SizedBox.shrink();
        }

        final (message, subMessage, icon, color) = _getMessage(state);

        return GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.base,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: color,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 20,
                    color: AppColors.textPrimary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          message,
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (subMessage != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            subMessage,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Icon(
                    Icons.keyboard_arrow_up,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  (String, String?, IconData, Color) _getMessage(SyncState state) {
    if (state is Offline) {
      return (
        'គ្មានអ៊ីនធឺណិត — Offline',
        state.pendingCount > 0
            ? '${state.pendingCount} items pending sync'
            : null,
        Icons.cloud_off,
        AppColors.warningLight,
      );
    } else if (state is SyncIdle) {
      return (
        'មានការផ្លាស់ប្តូរមិនទាន់ sync',
        '${state.pendingCount} items pending sync',
        Icons.cloud_upload,
        AppColors.warningLight,
      );
    } else if (state is SyncInProgress) {
      return (
        'កំពុងធ្វើសមកាលកម្ម...',
        '${state.processed}/${state.total} processed',
        Icons.sync,
        AppColors.primary.withValues(alpha: 0.2),
      );
    }

    return (
      'Offline',
      null,
      Icons.cloud_off,
      AppColors.warningLight,
    );
  }
}

/// Sync status sheet shown when user taps the badge or banner.
class SyncStatusSheet extends StatelessWidget {
  /// Creates a [SyncStatusSheet].
  const SyncStatusSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SyncBloc, SyncState>(
      builder: (context, state) {
        final lastSyncTime = switch (state) {
          SyncCompleted() => state.at,
          _ => (context.read<SyncBloc>()).lastSyncTime,
        };

        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppSpacing.lg),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  ),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sync Status',
                      style: AppTextStyles.headlineSmall,
                    ),
                    Text(
                      'ស្ថានភាពធ្វើសមកាលកម្ម',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Summary
              _buildSummary(context, state),

              const Divider(height: 1),

              // Last sync time
              if (lastSyncTime != null) ...[
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.base),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 16,
                        color: AppColors.success,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        'Last synced: ${_formatLastSync(lastSyncTime)}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const Divider(height: 1),

              // Actions
              Padding(
                padding: const EdgeInsets.all(AppSpacing.base),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          context.read<SyncBloc>().add(const RetryFailed());
                        },
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text('Retry Failed'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 44),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          context.read<SyncBloc>().add(const ForceSync());
                        },
                        icon: const Icon(Icons.sync, size: 18),
                        label: const Text('Force Sync'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(0, 44),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SafeArea(
                child: SizedBox(
                  height: AppSpacing.md,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummary(BuildContext context, SyncState state) {
    final (synced, pending, failed) = switch (state) {
      SyncInProgress() => (state.processed - state.failed, 0, state.failed),
      SyncCompleted() => (state.synced, 0, state.failed),
      SyncIdle() => (0, state.pendingCount, 0),
      Offline() => (0, state.pendingCount, 0),
      _ => (0, 0, 0),
    };

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.base),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem(
            label: 'Synced',
            labelKhmer: 'បានធ្វើសមកាល',
            count: synced,
            icon: Icons.cloud_done,
            color: AppColors.success,
          ),
          _buildSummaryItem(
            label: 'Pending',
            labelKhmer: 'រង់ចាំ',
            count: pending,
            icon: Icons.cloud_upload,
            color: AppColors.warning,
          ),
          _buildSummaryItem(
            label: 'Failed',
            labelKhmer: 'បរាជ័យ',
            count: failed,
            icon: Icons.error,
            color: AppColors.error,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required String label,
    required String labelKhmer,
    required int count,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: AppSpacing.xs),
        Text(
          '$count',
          style: AppTextStyles.headlineMedium.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          labelKhmer,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
            fontSize: 10,
          ),
        ),
      ],
    );
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
}

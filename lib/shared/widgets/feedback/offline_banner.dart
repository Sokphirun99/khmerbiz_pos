import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:khmerbiz_pos/core/theme/app_colors.dart';
import 'package:khmerbiz_pos/core/theme/app_spacing.dart';

/// KhmerBiz POS Offline Banner
///
/// Animated slide-down amber banner for offline mode.
///
/// Features:
/// - Animated slide in/out
/// - Shows pending sync count
/// - Auto-dismisses when back online
/// - Dismissible by user
/// - Bilingual text
///
/// Usage:
/// ```dart
/// // In Scaffold
/// Scaffold(
///   body: Stack(
///     children: [
///       // Main content
///       _buildContent(),
///       // Offline banner
///       OfflineBanner(
///         isPendingCount: 5,
///         isVisible: !isOnline,
///         onDismiss: () => _dismissBanner(),
///       ),
///     ],
///   ),
/// )
/// ```
class OfflineBanner extends StatefulWidget {

  const OfflineBanner({
    super.key,
    this.isPendingCount = 0,
    this.isVisible = false,
    this.onDismiss,
    this.onRetry,
    this.message,
    this.messageKhmer,
  });
  /// Number of pending items to sync
  final int isPendingCount;

  /// Whether banner is visible
  final bool isVisible;

  /// Callback when banner is dismissed
  final VoidCallback? onDismiss;

  /// Callback when user taps to retry sync
  final VoidCallback? onRetry;

  /// Custom message
  final String? message;

  /// Custom message (Khmer)
  final String? messageKhmer;

  @override
  State<OfflineBanner> createState() => _OfflineBannerState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('isPendingCount', isPendingCount));
    properties.add(DiagnosticsProperty<bool>('isVisible', isVisible));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onDismiss', onDismiss));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onRetry', onRetry));
    properties.add(StringProperty('message', message));
    properties.add(StringProperty('messageKhmer', messageKhmer));
  }
}

class _OfflineBannerState extends State<OfflineBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ),);

    if (widget.isVisible) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(OfflineBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: widget.isVisible ? 1.0 : 0.0,
        child: Visibility(
          visible: widget.isVisible,
          child: _buildBanner(),
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.warning,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.base,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              // Icon
              const Icon(
                Icons.cloud_off,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: AppSpacing.md),

              // Message
              Expanded(
                child: _buildMessage(),
              ),

              // Actions
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Retry button
                  if (widget.onRetry != null)
                    TextButton(
                      onPressed: widget.onRetry,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 32),
                      ),
                      child: const Text(
                        'Retry',
                        style: TextStyle(
                          fontFamily: 'Kantumruy Pro',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                  // Dismiss button
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: widget.onDismiss,
                    color: Colors.white,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessage() {
    final message = widget.message ?? _getDefaultMessage();
    final messageKhmer = widget.messageKhmer ?? _getDefaultMessageKhmer();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          messageKhmer,
          style: const TextStyle(
            fontFamily: 'Kantumruy Pro',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 1.4,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          message,
          style: const TextStyle(
            fontFamily: 'Kantumruy Pro',
            fontSize: 13,
            fontWeight: FontWeight.normal,
            height: 1.4,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  String _getDefaultMessage() {
    if (widget.isPendingCount > 0) {
      return 'Offline Mode — ${widget.isPendingCount} pending sync';
    }
    return 'Offline Mode — Changes will sync when online';
  }

  String _getDefaultMessageKhmer() {
    if (widget.isPendingCount > 0) {
      return 'គ្មានអ៊ីនធឺណិត — មាន ${widget.isPendingCount} ដែលត្រូវសមកាលកម្ម';
    }
    return 'គ្មានអ៊ីនធឺណិត — ទិន្នន័យនឹងសមកាលកម្មនៅពេលមានអ៊ីនធឺណិត';
  }
}

/// Compact offline indicator (for AppBar)
class OfflineIndicator extends StatelessWidget {

  const OfflineIndicator({
    super.key,
    this.pendingCount,
    this.onTap,
  });
  final int? pendingCount;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: AppColors.warning,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off,
              color: Colors.white,
              size: 16,
            ),
            const SizedBox(width: AppSpacing.xs),
            const Text(
              'Offline',
              style: TextStyle(
                fontFamily: 'Kantumruy Pro',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            if (pendingCount != null && pendingCount! > 0) ...[
              const SizedBox(width: AppSpacing.xs),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xs,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                ),
                child: Text(
                  '$pendingCount',
                  style: const TextStyle(
                    fontFamily: 'Roboto Mono',
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('pendingCount', pendingCount));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap));
  }
}

/// Connection status widget
class ConnectionStatus extends StatelessWidget {

  const ConnectionStatus({
    super.key,
    required this.isOnline,
    this.pendingCount = 0,
    this.lastSync,
    this.onRetry,
  });
  final bool isOnline;
  final int pendingCount;
  final DateTime? lastSync;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    if (isOnline) {
      return _buildOnlineStatus();
    } else {
      return _buildOfflineStatus();
    }
  }

  Widget _buildOnlineStatus() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.cloud_done,
          color: AppColors.success,
          size: 20,
        ),
        const SizedBox(width: AppSpacing.xs),
        if (lastSync != null)
          Text(
            'Synced ${_formatLastSync(lastSync!)}',
            style: const TextStyle(
              fontFamily: 'Kantumruy Pro',
              fontSize: 12,
              color: AppColors.success,
            ),
          )
        else
          const Text(
            'Online',
            style: TextStyle(
              fontFamily: 'Kantumruy Pro',
              fontSize: 12,
              color: AppColors.success,
            ),
          ),
      ],
    );
  }

  Widget _buildOfflineStatus() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.cloud_off,
          color: AppColors.warning,
          size: 20,
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          pendingCount > 0
              ? '$pendingCount pending'
              : 'Offline',
          style: const TextStyle(
            fontFamily: 'Kantumruy Pro',
            fontSize: 12,
            color: AppColors.warning,
          ),
        ),
        if (onRetry != null) ...[
          const SizedBox(width: AppSpacing.sm),
          GestureDetector(
            onTap: onRetry,
            child: const Icon(
              Icons.refresh,
              color: AppColors.warning,
              size: 18,
            ),
          ),
        ],
      ],
    );
  }

  String _formatLastSync(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) {
      return 'just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${time.day}/${time.month}';
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('isOnline', isOnline));
    properties.add(IntProperty('pendingCount', pendingCount));
    properties.add(DiagnosticsProperty<DateTime?>('lastSync', lastSync));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onRetry', onRetry));
  }
}

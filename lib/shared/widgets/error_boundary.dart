import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Error boundary widget to catch and display unhandled errors.
///
/// This widget wraps parts of the application and catches any unhandled
/// exceptions, displaying a user-friendly error screen instead of crashing.
///
/// Usage:
/// ```dart
/// ErrorBoundary(
///   child: MyWidget(),
/// )
/// ```
final class ErrorBoundary extends StatefulWidget {
  const ErrorBoundary({
    required this.child,
    super.key,
    this.errorBuilder,
    this.onError,
  });
  final Widget child;
  final Widget Function(Object error, StackTrace stackTrace)? errorBuilder;
  final void Function(Object error, StackTrace stackTrace)? onError;

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<
            Widget Function(Object error, StackTrace stackTrace)?>.has(
        'errorBuilder', errorBuilder,),);
    properties.add(ObjectFlagProperty<
        void Function(
            Object error, StackTrace stackTrace,)?>.has('onError', onError),);
  }
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  bool _hasError = false;
  Object? _error;
  StackTrace? _stackTrace;

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      widget.onError?.call(_error!, _stackTrace!);

      if (widget.errorBuilder != null) {
        return widget.errorBuilder!(_error!, _stackTrace!);
      }

      return _buildDefaultErrorScreen();
    }

    return _ErrorBoundaryScope(
      onError: _handleError,
      child: widget.child,
    );
  }

  void _handleError(Object error, StackTrace stackTrace) {
    if (mounted) {
      setState(() {
        _hasError = true;
        _error = error;
        _stackTrace = stackTrace;
      });
    }
  }

  Widget _buildDefaultErrorScreen() {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Something went wrong',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'We encountered an unexpected error.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                if (_error != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _error.toString(),
                      style: const TextStyle(fontSize: 12),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _hasError = false;
                      _error = null;
                      _stackTrace = null;
                    });
                  },
                  child: const Text('Try Again'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Scope for error boundary to catch errors in child widgets.
class _ErrorBoundaryScope extends InheritedWidget {
  const _ErrorBoundaryScope({
    required super.child,
    required this.onError,
  });
  final void Function(Object error, StackTrace stackTrace) onError;

  @override
  bool updateShouldNotify(_ErrorBoundaryScope oldWidget) => false;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<
        void Function(
            Object error, StackTrace stackTrace,)>.has('onError', onError),);
  }
}

/// Report an error to the nearest error boundary.
///
/// This function is intentionally left unused in the skeleton.
/// It will be used when error reporting is implemented.
// ignore: unused_element
void _reportError(BuildContext context, Object error, StackTrace stackTrace) {
  final scope =
      context.dependOnInheritedWidgetOfExactType<_ErrorBoundaryScope>();
  scope?.onError(error, stackTrace);
}

/// Default error widget for small sections.
final class DefaultErrorWidget extends StatelessWidget {
  const DefaultErrorWidget({
    required this.error,
    required this.stackTrace,
    super.key,
    this.onRetry,
  });
  final Object error;
  final StackTrace stackTrace;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red.shade700, size: 20),
              const SizedBox(width: 8),
              Text(
                'Error',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: TextStyle(color: Colors.red.shade900, fontSize: 12),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            TextButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Object>('error', error));
    properties.add(DiagnosticsProperty<StackTrace>('stackTrace', stackTrace));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onRetry', onRetry));
  }
}

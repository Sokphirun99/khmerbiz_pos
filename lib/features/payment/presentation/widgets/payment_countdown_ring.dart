import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:khmerbiz_pos/core/theme/app_colors.dart';

/// Circular countdown ring that wraps around the QR code.
///
/// Displays a progress ring that depletes as time runs out.
/// Changes color from blue → yellow → red as time decreases.
class PaymentCountdownRing extends StatelessWidget {
  const PaymentCountdownRing({
    super.key,
    required this.remaining,
    required this.total,
    required this.child,
    this.strokeWidth = 4,
    this.padding = 16,
  });

  /// Remaining duration.
  final Duration remaining;

  /// Total duration (for calculating progress).
  final Duration total;

  /// Child widget (QR code) to display inside the ring.
  final Widget child;

  /// Width of the ring stroke.
  final double strokeWidth;

  /// Padding between ring and child.
  final double padding;

  @override
  Widget build(BuildContext context) {
    final progress = total.inSeconds > 0
        ? remaining.inSeconds / total.inSeconds
        : 0.0;

    final ringColor = _getColorForProgress(progress);

    return CustomPaint(
      painter: _CountdownRingPainter(
        progress: progress.clamp(0.0, 1.0),
        color: ringColor,
        backgroundColor: AppColors.borderLight,
        strokeWidth: strokeWidth,
      ),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: child,
      ),
    );
  }

  Color _getColorForProgress(double progress) {
    if (progress > 0.5) return AppColors.khqrBlue;
    if (progress > 0.2) return AppColors.warning;
    return AppColors.error;
  }
}

class _CountdownRingPainter extends CustomPainter {
  _CountdownRingPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  final double progress;
  final Color color;
  final Color backgroundColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (math.min(size.width, size.height) / 2) - strokeWidth / 2;

    // Background ring
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress ring
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Start from top
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_CountdownRingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

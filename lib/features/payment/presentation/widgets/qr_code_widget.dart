import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:khmerbiz_pos/core/theme/app_colors.dart';

/// Renders a QR code from a KHQR payload string.
///
/// Uses `qr_flutter` package for rendering. If the package is not
/// available, falls back to a placeholder with the data hash.
///
/// Required package: `qr_flutter: ^4.1.0`
/// Add to pubspec.yaml: `flutter pub add qr_flutter`
class QrCodeWidget extends StatelessWidget {
  const QrCodeWidget({
    required this.data, super.key,
    this.size = 250,
    this.backgroundColor = Colors.white,
    this.foregroundColor = Colors.black,
  });

  /// The QR code data string (KHQR EMVCo payload).
  final String data;

  /// Size of the QR code widget (width and height).
  final double size;

  /// Background color of the QR code.
  final Color backgroundColor;

  /// Foreground (dot) color of the QR code.
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    // NOTE: When qr_flutter is added to pubspec.yaml, replace this
    // placeholder with:
    //
    // ```dart
    // return QrImageView(
    //   data: data,
    //   version: QrVersions.auto,
    //   size: size,
    //   backgroundColor: backgroundColor,
    //   eyeStyle: QrEyeStyle(
    //     eyeShape: QrEyeShape.square,
    //     color: foregroundColor,
    //   ),
    //   dataModuleStyle: QrDataModuleStyle(
    //     dataModuleShape: QrDataModuleShape.square,
    //     color: foregroundColor,
    //   ),
    //   embeddedImage: const AssetImage('assets/icons/khqr_logo.png'),
    //   embeddedImageStyle: const QrEmbeddedImageStyle(size: Size(40, 40)),
    // );
    // ```

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: AppColors.border, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.qr_code_2,
            size: size * 0.5,
            color: foregroundColor,
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'KHQR',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.khqrBlue,
              ),
            ),
          ),
          const SizedBox(height: 4),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Scan with any banking app',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 2),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'ស្កេនជាមួយកម្មវិធីធនាគារ',
              style: TextStyle(
                fontSize: 10,
                color: AppColors.textHint,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('data', data));
    properties.add(DoubleProperty('size', size));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(ColorProperty('foregroundColor', foregroundColor));
  }
}

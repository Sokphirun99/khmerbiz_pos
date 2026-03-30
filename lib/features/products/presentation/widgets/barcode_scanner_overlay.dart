import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:khmerbiz_pos/core/theme/app_colors.dart';
import 'package:khmerbiz_pos/core/theme/app_spacing.dart';
import 'package:khmerbiz_pos/core/theme/app_text_styles.dart';

/// Full-screen barcode scanner overlay.
///
/// Uses `mobile_scanner` package for camera-based barcode detection.
/// Returns the scanned barcode string via [Navigator.pop].
class BarcodeScannerOverlay extends StatefulWidget {
  const BarcodeScannerOverlay({super.key});

  /// Show the scanner as a modal route and return the barcode string.
  static Future<String?> show(BuildContext context) {
    return Navigator.of(context).push<String>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => const BarcodeScannerOverlay(),
      ),
    );
  }

  @override
  State<BarcodeScannerOverlay> createState() => _BarcodeScannerOverlayState();
}

class _BarcodeScannerOverlayState extends State<BarcodeScannerOverlay> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  bool _hasScanned = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_hasScanned) return;
    final barcodes = capture.barcodes;
    if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
      _hasScanned = true;
      Navigator.of(context).pop(barcodes.first.rawValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          'Scan Barcode',
          style: AppTextStyles.headlineMedium.copyWith(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: _controller,
              builder: (context, state, child) {
                return Icon(
                  state.torchState == TorchState.on
                      ? Icons.flash_on
                      : Icons.flash_off,
                  color: state.torchState == TorchState.on
                      ? AppColors.accent
                      : Colors.white,
                );
              },
            ),
            onPressed: () => _controller.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Icons.cameraswitch, color: Colors.white),
            onPressed: () => _controller.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Camera preview
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
          ),

          // Scan area overlay
          _buildScanOverlay(context),

          // Instructions
          Positioned(
            bottom: AppSpacing.xxl,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius:
                      BorderRadius.circular(AppSpacing.radiusMedium),
                ),
                child: Text(
                  'Point camera at barcode',
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
          ),

          // Manual entry button
          Positioned(
            bottom: AppSpacing.base,
            left: AppSpacing.pageHorizontal,
            right: AppSpacing.pageHorizontal,
            child: TextButton(
              onPressed: () => _showManualEntry(context),
              child: Text(
                'Enter barcode manually',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.accent,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanOverlay(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scanAreaSize = size.width * 0.7;

    return ColorFiltered(
      colorFilter: const ColorFilter.mode(
        Colors.black54,
        BlendMode.srcOut,
      ),
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.black,
              backgroundBlendMode: BlendMode.dstOut,
            ),
          ),
          Center(
            child: Container(
              width: scanAreaSize,
              height: scanAreaSize * 0.6,
              decoration: BoxDecoration(
                color: Colors.red, // Will be cut out
                borderRadius:
                    BorderRadius.circular(AppSpacing.radiusMedium),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showManualEntry(BuildContext context) async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Enter Barcode'),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: 'Barcode number',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, controller.text),
            child: const Text('OK'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty && mounted) {
      Navigator.of(context).pop(result);
    }
  }
}

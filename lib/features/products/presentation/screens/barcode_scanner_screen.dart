import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:khmerbiz_pos/core/theme/app_colors.dart';
import 'package:khmerbiz_pos/core/theme/app_spacing.dart';
import 'package:khmerbiz_pos/core/theme/app_text_styles.dart';
import 'package:khmerbiz_pos/features/products/presentation/bloc/product_bloc.dart';
import 'package:khmerbiz_pos/features/products/presentation/bloc/product_event.dart';
import 'package:khmerbiz_pos/features/products/presentation/bloc/product_state.dart';
import 'package:khmerbiz_pos/features/products/presentation/widgets/product_grid_item.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// A screen that provides barcode scanning functionality using the device camera.
class BarcodeScannerScreen extends StatefulWidget {
  /// Creates a [BarcodeScannerScreen].
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  final MobileScannerController _controller = MobileScannerController();
  bool _isScanned = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isScanned) return;

    final barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final code = barcodes.first.rawValue;
      if (code != null) {
        setState(() => _isScanned = true);
        context.read<ProductBloc>().add(BarcodeDetected(barcode: code));
        // Haptic feedback could be added here
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera View
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
          ),

          // Scanning Overlay
          _buildOverlay(),

          // Back Button
          Positioned(
            top: MediaQuery.of(context).padding.top + AppSpacing.sm,
            left: AppSpacing.pageHorizontal,
            child: CircleAvatar(
              backgroundColor: Colors.black54,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => context.pop(),
              ),
            ),
          ),

          // Torch & Switch Camera
          Positioned(
            top: MediaQuery.of(context).padding.top + AppSpacing.sm,
            right: AppSpacing.pageHorizontal,
            child: Row(
              children: [
                ValueListenableBuilder<MobileScannerState>(
                  valueListenable: _controller,
                  builder: (context, state, child) {
                    final isTorchOn = state.torchState == TorchState.on;
                    return CircleAvatar(
                      backgroundColor: Colors.black54,
                      child: IconButton(
                        icon: Icon(
                          isTorchOn ? Icons.flash_on : Icons.flash_off,
                          color: isTorchOn ? AppColors.accent : Colors.white,
                        ),
                        onPressed: _controller.toggleTorch,
                      ),
                    );
                  },
                ),
                const SizedBox(width: AppSpacing.sm),
                CircleAvatar(
                  backgroundColor: Colors.black54,
                  child: IconButton(
                    icon: const Icon(Icons.flip_camera_ios, color: Colors.white),
                    onPressed: _controller.switchCamera,
                  ),
                ),
              ],
            ),
          ),

          // Product Popup or Result Loader
          _buildResultOverlay(context),
        ],
      ),
    );
  }

  Widget _buildOverlay() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scanAreaSize = constraints.maxWidth * 0.7;
        return Stack(
          children: [
            ColorFiltered(
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
                      height: scanAreaSize,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusMedium),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const AnimatedScanLine(),
          ],
        );
      },
    );
  }

  Widget _buildResultOverlay(BuildContext context) {
    return BlocConsumer<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is BarcodeNotFound) {
          // Keep scanner active but show error or option to create
        }
      },
      builder: (context, state) {
        if (state is BarcodeScanning) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.accent),
          );
        }

        if (state is ProductScanned) {
          return Positioned(
            bottom: AppSpacing.lg,
            left: AppSpacing.pageHorizontal,
            right: AppSpacing.pageHorizontal,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 100, end: 0),
              duration: const Duration(milliseconds: 300),
              builder: (context, value, child) => Transform.translate(
                offset: Offset(0, value),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.check_circle, color: AppColors.success),
                            const SizedBox(width: AppSpacing.sm),
                            Text('Product Found', style: AppTextStyles.buttonLabel),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        ProductGridItem(
                          product: state.product,
                          onTap: () {}, // Handled by buttons below
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  setState(() => _isScanned = false);
                                  context.read<ProductBloc>().add(const ScanBarcode());
                                },
                                child: const Text('Rescan'),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () {
                                  context.pop(state.product);
                                },
                                child: const Text('Confirm'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

/// A widget that displays an animated scanning line effect.
class AnimatedScanLine extends StatefulWidget {
  /// Creates an [AnimatedScanLine].
  const AnimatedScanLine({super.key});

  @override
  State<AnimatedScanLine> createState() => _AnimatedScanLineState();
}

class _AnimatedScanLineState extends State<AnimatedScanLine>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            height: 2,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.5),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
              color: AppColors.accent,
            ),
            transform: Matrix4.translationValues(
              0,
              (MediaQuery.of(context).size.width * 0.7) *
                  (_controller.value - 0.5),
              0,
            ),
          ),
        );
      },
    );
  }
}

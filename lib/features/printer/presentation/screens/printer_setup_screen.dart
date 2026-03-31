import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khmerbiz_pos/core/theme/app_colors.dart';
import 'package:khmerbiz_pos/core/theme/app_spacing.dart';
import 'package:khmerbiz_pos/core/theme/app_text_styles.dart';
import 'package:khmerbiz_pos/domain/entities/printer.dart';
import 'package:khmerbiz_pos/features/printer/presentation/bloc/printer_bloc.dart';
import 'package:khmerbiz_pos/features/printer/presentation/bloc/printer_event.dart';
import 'package:khmerbiz_pos/features/printer/presentation/bloc/printer_state.dart';
import 'package:khmerbiz_pos/features/printer/presentation/widgets/printer_widgets.dart';
import 'package:khmerbiz_pos/shared/widgets/buttons/app_button.dart';

/// Printer setup screen for scanning, connecting, and configuring printers.
class PrinterSetupScreen extends StatelessWidget {
  /// Creates a [PrinterSetupScreen].
  const PrinterSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          'Printer Setup',
          style: AppTextStyles.headlineLarge.copyWith(
            color: AppColors.primary,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: AppButton(
              label: 'Save',
              labelKhmer: 'រក្សាទុក',
              type: AppButtonType.accent,
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
      body: BlocConsumer<PrinterBloc, PrinterState>(
        listener: (context, state) {
          if (state is PrinterError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.failure.messageEn),
                backgroundColor: AppColors.error,
              ),
            );
          } else if (state is PrinterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Print successful: ${state.transactionId}'),
                backgroundColor: AppColors.success,
              ),
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              // Connection Status Card
              _buildStatusCard(context, state),
              const SizedBox(height: AppSpacing.md),
              // Paper Size & Font Size Settings
              _buildSettingsCard(context),
              const SizedBox(height: AppSpacing.md),
              // Device List
              Expanded(
                child: _buildDeviceList(context, state),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context, PrinterState state) {
    final isConnected = state is PrinterConnected;
    final deviceName = switch (state) {
      PrinterConnected(:final device) => device.name,
      PrinterConnecting(:final device) => device.name,
      _ => 'No printer connected',
    };

    return Container(
      margin: const EdgeInsets.all(AppSpacing.pageHorizontal),
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(
          color: isConnected ? AppColors.success : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isConnected ? Icons.print : Icons.print_disabled,
            color: isConnected ? AppColors.success : AppColors.textHint,
            size: 32,
          ),
          const SizedBox(width: AppSpacing.base),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isConnected ? 'Printer Connected' : 'No Printer',
                  style: AppTextStyles.bodyStrong.copyWith(
                    color: isConnected ? AppColors.success : AppColors.textSecondary,
                  ),
                ),
                Text(
                  deviceName,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
          if (isConnected)
            OutlinedButton(
              onPressed: () {
                context.read<PrinterBloc>().add(const DisconnectPrinter());
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
              ),
              child: const Text('Disconnect'),
            ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context) {
    final state = context.watch<PrinterBloc>().state;
    final paperSize = switch (state) {
      PrinterConnected(:final paperSize) => paperSize,
      _ => PaperSize.mm80,
    };

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Paper Size',
            style: AppTextStyles.bodyStrong,
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              _buildPaperSizeChip(
                context,
                label: '58mm',
                size: PaperSize.mm58,
                isSelected: paperSize == PaperSize.mm58,
              ),
              const SizedBox(width: AppSpacing.sm),
              _buildPaperSizeChip(
                context,
                label: '80mm',
                size: PaperSize.mm80,
                isSelected: paperSize == PaperSize.mm80,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Font Size',
            style: AppTextStyles.bodyStrong,
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              _buildFontSizeChip(
                context,
                label: 'Normal',
                size: PrinterFontSize.normal,
                isSelected: true,
              ),
              const SizedBox(width: AppSpacing.sm),
              _buildFontSizeChip(
                context,
                label: 'Large',
                size: PrinterFontSize.large,
                isSelected: false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaperSizeChip(
    BuildContext context, {
    required String label,
    required PaperSize size,
    required bool isSelected,
  }) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          context.read<PrinterBloc>().add(SetPaperSize(size: size));
        }
      },
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.onPrimary : AppColors.textPrimary,
      ),
    );
  }

  Widget _buildFontSizeChip(
    BuildContext context, {
    required String label,
    required PrinterFontSize size,
    required bool isSelected,
  }) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          context.read<PrinterBloc>().add(SetFontSize(size: size));
        }
      },
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.onPrimary : AppColors.textPrimary,
      ),
    );
  }

  Widget _buildDeviceList(BuildContext context, PrinterState state) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.pageHorizontal),
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Available Printers',
                style: AppTextStyles.bodyStrong,
              ),
              AppButton.secondary(
                label: 'Scan',
                labelKhmer: 'ស្កេន',
                icon: Icons.bluetooth_searching,
                onTap: () {
                  context.read<PrinterBloc>().add(const ScanForPrinters());
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: _buildDeviceListContent(context, state),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceListContent(BuildContext context, PrinterState state) {
    return switch (state) {
      PrinterScanning(foundDevices: final devices) => devices.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : _buildDeviceList(devices, context, null),
      PrinterConnected(device: final device, :final foundDevices) =>
          _buildDeviceList(foundDevices, context, device),
      PrinterDisconnected() => const PrinterEmptyState(
          message: 'No printers found.\nTap Scan to search for printers.',
          icon: Icons.bluetooth_disabled,
        ),
      _ => const PrinterEmptyState(
          message: 'Connect to a printer to print receipts.',
          icon: Icons.print_disabled,
        ),
    };
  }

  Widget _buildDeviceList(
    List<BluetoothPrinterDevice> devices,
    BuildContext context,
    BluetoothPrinterDevice? connectedDevice,
  ) {
    return ListView.separated(
      itemCount: devices.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final device = devices[index];
        final isConnected = connectedDevice?.address == device.address;

        return _buildDeviceTile(
          context,
          device: device,
          isConnected: isConnected ?? false,
        );
      },
    );
  }

  Widget _buildDeviceTile(
    BuildContext context, {
    required BluetoothPrinterDevice device,
    required bool isConnected,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
        border: Border.all(
          color: isConnected ? AppColors.success : Colors.transparent,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isConnected ? Icons.print : Icons.bluetooth,
            color: isConnected ? AppColors.success : AppColors.primary,
          ),
          const SizedBox(width: AppSpacing.base),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device.name,
                  style: AppTextStyles.bodyStrong,
                ),
                Text(
                  device.address,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
          if (device.signalStrength != null)
            Icon(
              Icons.signal_cellular_4_bar,
              color: device.hasGoodSignal
                  ? AppColors.success
                  : device.hasWeakSignal
                      ? AppColors.warning
                      : AppColors.error,
              size: 20,
            ),
          const SizedBox(width: AppSpacing.sm),
          if (isConnected)
            const Icon(
              Icons.check_circle,
              color: AppColors.success,
            )
          else
            OutlinedButton(
              onPressed: () {
                context.read<PrinterBloc>().add(ConnectPrinter(device: device));
              },
              child: const Text('Connect'),
            ),
        ],
      ),
    );
  }
}

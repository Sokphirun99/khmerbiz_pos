import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:khmerbiz_pos/core/theme/app_colors.dart';
import 'package:khmerbiz_pos/core/theme/app_spacing.dart';
import 'package:khmerbiz_pos/core/theme/app_text_styles.dart';
import 'package:khmerbiz_pos/core/utils/currency_formatter.dart';
import 'package:khmerbiz_pos/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:khmerbiz_pos/features/settings/presentation/bloc/settings_state.dart';
import 'package:khmerbiz_pos/shared/widgets/feedback/app_snackbar.dart';

/// Screen for managing application settings, including exchange rates.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsBloc(context.read())..add(const LoadSettings()),
      child: BlocConsumer<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is SettingsError) {
            AppSnackbar.show(context, message: state.message, isError: true);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Settings / ការកំណត់'),
              actions: [
                if (state is SettingsLoaded && state.isRefreshing)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ),
              ],
            ),
            body: ListView(
              padding: const EdgeInsets.all(AppSpacing.base),
              children: [
                _buildExchangeRateSection(context, state),
                const SizedBox(height: AppSpacing.lg),
                _buildSettingsSection(
                  context,
                  title: 'Business Info / ព័ត៌មានអាជីវកម្ម',
                  onTap: () => context.go('/settings/business'),
                  icon: Icons.business,
                ),
                _buildSettingsSection(
                  context,
                  title: 'Printer / ម៉ាស៊ីនបោះពុម្ព',
                  onTap: () => context.go('/settings/printer'),
                  icon: Icons.print,
                ),
                _buildSettingsSection(
                  context,
                  title: 'Language / ភាសា',
                  onTap: () => context.go('/settings/language'),
                  icon: Icons.language,
                ),
                const SizedBox(height: AppSpacing.xl),
                _buildAboutSection(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildExchangeRateSection(BuildContext context, SettingsState state) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.md),
        side: BorderSide(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Exchange Rate',
                      style: AppTextStyles.headlineSmall,
                    ),
                    Text(
                      'អត្រាប្តូរប្រាក់',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                IconButton.filledTonal(
                  onPressed: state is SettingsLoading
                      ? null
                      : () => context.read<SettingsBloc>().add(const RefreshExchangeRate()),
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Refresh Now',
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            if (state is SettingsLoading && state is! SettingsLoaded)
              const Center(child: LinearProgressIndicator())
            else if (state is SettingsLoaded) ...[
              Row(
                children: [
                  _buildCurrencyBox('USD', '1.00'),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: Icon(Icons.compare_arrows, color: AppColors.khqrBlue),
                  ),
                  _buildCurrencyBox('KHR', state.exchangeRate.rate.formatKHR),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Last updated:',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint),
                      ),
                      Text(
                        DateFormat('yyyy-MM-dd HH:mm').format(state.exchangeRate.fetchedAt),
                        style: AppTextStyles.bodySmall.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: state.exchangeRate.source == 'nbc'
                          ? AppColors.success.withValues(alpha: 0.1)
                          : AppColors.warning.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      state.exchangeRate.source.toUpperCase(),
                      style: AppTextStyles.labelSmall.copyWith(
                        color: state.exchangeRate.source == 'nbc'
                            ? AppColors.success
                            : AppColors.warning,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ] else
              const Center(child: Text('Failed to load exchange rate')),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyBox(String code, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.surfaceAlt,
          borderRadius: BorderRadius.circular(AppSpacing.sm),
        ),
        child: Column(
          children: [
            Text(code, style: AppTextStyles.labelMedium),
            Text(
              value,
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(
    BuildContext context, {
    required String title,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.khqrBlue),
      title: Text(title, style: AppTextStyles.bodyLarge),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textHint),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Opacity(
            opacity: 0.2,
            child: Icon(Icons.qr_code_2, size: 48),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'KhmerBiz POS v1.0.0',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint),
          ),
          Text(
            'Powered by Bakong KHQR',
            style: AppTextStyles.labelSmall.copyWith(color: AppColors.khqrBlue),
          ),
        ],
      ),
    );
  }
}

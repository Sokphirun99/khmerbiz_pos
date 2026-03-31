import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:khmerbiz_pos/core/theme/app_colors.dart';
import 'package:khmerbiz_pos/core/theme/app_spacing.dart';
import 'package:khmerbiz_pos/core/theme/app_text_styles.dart';
import 'package:khmerbiz_pos/shared/widgets/displays/sync_status_badge.dart';
import 'package:khmerbiz_pos/shared/widgets/layouts/section_header.dart';

/// Settings screen with role-gated sections.
class SettingsScreen extends StatelessWidget {
  /// Creates a [SettingsScreen].
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              'ការកំណត់',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: const [
          SyncStatusBadge(
            status: SyncStatus.pending,
            pendingCount: 3,
          ),
          SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
        children: [
          // Business Info section
          _buildSection(
            context,
            titleEn: 'Business Info',
            titleKh: 'ព័ត៌មានអាជីវកម្ម',
            items: [
              _buildSettingItem(
                icon: Icons.business,
                titleEn: 'Business Details',
                titleKh: 'ព័ត៌មានអាជីវកម្ម',
                subtitle: 'Name, Address, Tax Rate',
                onTap: () => context.push('/settings/business'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Payment section
          _buildSection(
            context,
            titleEn: 'Payment',
            titleKh: 'ការទូទាត់',
            items: [
              _buildSettingItem(
                icon: Icons.qr_code,
                titleEn: 'KHQR Settings',
                titleKh: 'ការកំណត់ KHQR',
                subtitle: 'Merchant ID, Bank',
                onTap: () {},
              ),
              _buildSettingItem(
                icon: Icons.currency_exchange,
                titleEn: 'Exchange Rate',
                titleKh: 'អត្រាប្តូរ',
                subtitle: '1 USD = 4,100 ៛',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Printer section
          _buildSection(
            context,
            titleEn: 'Printer',
            titleKh: 'ម៉ាស៊ីនបោះពុម្ព',
            items: [
              _buildSettingItem(
                icon: Icons.print,
                titleEn: 'Printer Setup',
                titleKh: 'ការកំណត់ម៉ាស៊ីនបោះពុម្ព',
                subtitle: 'Not Connected',
                trailing: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                ),
                onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Printer setup coming in v1.1.0'),
                  ),
                );
              },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Staff section (admin only)
          _buildSection(
            context,
            titleEn: 'Staff',
            titleKh: 'បុគ្គលិក',
            isAdminOnly: true,
            items: [
              _buildSettingItem(
                icon: Icons.people,
                titleEn: 'Manage Staff',
                titleKh: 'គ្រប់គ្រងបុគ្គលិក',
                onTap: () => context.push('/settings/staff'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Data & Sync section
          _buildSection(
            context,
            titleEn: 'Data & Sync',
            titleKh: 'ទិន្នន័យ និង សមកាល',
            items: [
              _buildSettingItem(
                icon: Icons.sync,
                titleEn: 'Sync Now',
                titleKh: 'សមកាលឥឡូវ',
                subtitle: '3 items pending',
                onTap: () {},
              ),
              _buildSettingItem(
                icon: Icons.storage,
                titleEn: 'Storage',
                titleKh: 'ផ្ទុក',
                subtitle: '45 MB used',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // App Preferences section
          _buildSection(
            context,
            titleEn: 'Preferences',
            titleKh: 'ចំណូលចិត្ត',
            items: [
              _buildSettingItem(
                icon: Icons.language,
                titleEn: 'Language',
                titleKh: 'ភាសា',
                subtitle: 'English',
                onTap: () {},
              ),
              _buildSettingItem(
                icon: Icons.brightness_2,
                titleEn: 'Dark Mode',
                titleKh: 'របៀបងងឹត',
                trailing: Switch(
                  value: false,
                  onChanged: (value) {},
                  activeThumbColor: AppColors.primary,
                ),
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // About section
          _buildSection(
            context,
            titleEn: 'About',
            titleKh: 'អំពី',
            items: [
              _buildSettingItem(
                icon: Icons.info,
                titleEn: 'App Version',
                titleKh: 'កំណែកម្មវិធី',
                subtitle: '1.0.0+1',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String titleEn,
    required String titleKh,
    required List<Widget> items,
    bool isAdminOnly = false,
  }) {
    // In production, check user role here
    if (isAdminOnly) {
      // For demo, show admin-only sections
      // In real app: return isAdmin ? _buildSectionContent(...) : SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: titleEn,
          titleKhmer: titleKh,
        ),
        const SizedBox(height: AppSpacing.sm),
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          ),
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String titleEn,
    String? titleKh,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary, size: 24),
      title: Text(
        titleEn,
        style: AppTextStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            )
          : null,
      trailing: trailing ??
          const Icon(
            Icons.chevron_right,
            color: AppColors.textHint,
          ),
      onTap: onTap,
    );
  }
}

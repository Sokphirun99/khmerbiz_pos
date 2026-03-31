import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:khmerbiz_pos/core/router/app_router.dart';
import 'package:khmerbiz_pos/core/theme/app_colors.dart';
import 'package:khmerbiz_pos/core/theme/app_spacing.dart';
import 'package:khmerbiz_pos/core/theme/app_text_styles.dart';
import 'package:khmerbiz_pos/features/home/presentation/bloc/home_bloc.dart';
import 'package:khmerbiz_pos/features/home/presentation/bloc/home_event.dart';
import 'package:khmerbiz_pos/features/home/presentation/bloc/home_state.dart';
import 'package:khmerbiz_pos/features/home/presentation/widgets/dashboard_card.dart';
import 'package:khmerbiz_pos/features/home/presentation/widgets/quick_action_button.dart';
import 'package:khmerbiz_pos/features/home/presentation/widgets/recent_transaction_tile.dart';
import 'package:khmerbiz_pos/features/home/presentation/widgets/top_product_tile.dart';
import 'package:khmerbiz_pos/features/home/presentation/widgets/weekly_chart.dart';
import 'package:khmerbiz_pos/shared/widgets/feedback/empty_state.dart';
import 'package:khmerbiz_pos/shared/widgets/layouts/section_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.surface,
            elevation: 0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dashboard',
                  style: AppTextStyles.headlineLarge.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  'ផ្ទាំងគ្រប់គ្រង',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  context.read<HomeBloc>().add(const RefreshDashboard());
                },
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, HomeState state) {
    return switch (state) {
      HomeInitial() || HomeLoading() => const _LoadingBody(),
      HomeLoaded() => _LoadedBody(state: state),
      HomeError() => _ErrorBody(failure: state.failure),
    };
  }
}

class _LoadingBody extends StatelessWidget {
  const _LoadingBody();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          height: 300,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
          ),
        ),
      ],
    );
  }
}

class _LoadedBody extends StatelessWidget {
  const _LoadedBody({required this.state});

  final HomeLoaded state;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<HomeBloc>().add(const RefreshDashboard());
      },
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDashboardCards(context),
                  const SizedBox(height: AppSpacing.md),
                  WeeklyChart(data: state.weeklyData),
                  const SizedBox(height: AppSpacing.md),
                  const SectionHeader(
                    title: 'Quick Actions',
                    titleKhmer: 'ការធ្វើសកម្មភាពរហ័ស',
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  QuickActionGrid(actions: _buildQuickActions(context)),
                  if (state.topProducts.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    const SectionHeader(
                      title: 'Top Products',
                      titleKhmer: 'ផលិតផលល្អបំផុត',
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ...state.topProducts.asMap().entries.map(
                          (e) => TopProductTile(
                            product: e.value,
                            rank: e.key + 1,
                          ),
                        ),
                  ],
                  const SizedBox(height: AppSpacing.md),
                  const SectionHeader(
                    title: 'Recent Transactions',
                    titleKhmer: 'ប្រតិបត្តិការថ្មីៗ',
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  if (state.recentTransactions.isEmpty)
                    const EmptyState(variant: EmptyStateVariant.noTransactions)
                  else
                    ...state.recentTransactions.map(
                      (tx) => RecentTransactionTile(transaction: tx),
                    ),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCards(BuildContext context) {
    final summary = state.dailySummary;

    return Row(
      children: [
        DashboardCard(
          icon: Icons.payments_outlined,
          label: "Today's Revenue",
          value: summary != null
              ? '${summary.totalRevenue.toStringAsFixed(0)}៛'
              : '0៛',
          subtitle: summary != null
              ? '\$${summary.totalRevenueUSD.toStringAsFixed(2)} · ${summary.totalTransactions} sales'
              : 'No sales yet',
        ),
        const SizedBox(width: AppSpacing.sm),
        DashboardCard(
          icon: Icons.inventory_2_outlined,
          label: 'Low Stock',
          value: '${state.lowStockCount}',
          subtitle:
              state.lowStockCount > 0 ? 'items need restock' : 'All stocked',
          accentColor:
              state.lowStockCount > 0 ? AppColors.warning : AppColors.success,
        ),
        const SizedBox(width: AppSpacing.sm),
        DashboardCard(
          icon: Icons.cloud_upload_outlined,
          label: 'Pending Sync',
          value: '${state.pendingSync}',
          subtitle: state.pendingSync > 0 ? 'items to sync' : 'All synced',
          accentColor:
              state.pendingSync > 0 ? AppColors.info : AppColors.success,
        ),
      ],
    );
  }

  List<QuickAction> _buildQuickActions(BuildContext context) {
    return [
      QuickAction(
        icon: Icons.point_of_sale,
        label: 'POS',
        onTap: () => context.go(AppRouter.pos),
        bgColor: AppColors.primary.withOpacity(0.1),
      ),
      QuickAction(
        icon: Icons.add_circle_outline,
        label: 'Add Product',
        onTap: () => context.push(AppRouter.productAdd),
        iconColor: AppColors.accent,
        bgColor: AppColors.accentLight,
      ),
      QuickAction(
        icon: Icons.inventory,
        label: 'Stock Adj.',
        onTap: () => context.go(AppRouter.inventory),
        iconColor: AppColors.info,
        bgColor: AppColors.infoLight,
      ),
      QuickAction(
        icon: Icons.people_outline,
        label: 'Customers',
        onTap: () => context.go(AppRouter.customers),
        iconColor: AppColors.success,
        bgColor: AppColors.successLight,
      ),
    ];
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<HomeLoaded>('state', state));
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.failure});

  final dynamic failure;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Failed to load dashboard',
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'បរាជ័យក្នុងការផ្ទុកផ្ទាំងគ្រប់គ្រង',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton.icon(
              onPressed: () {
                context.read<HomeBloc>().add(const LoadDashboard());
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.base,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('failure', failure));
  }
}

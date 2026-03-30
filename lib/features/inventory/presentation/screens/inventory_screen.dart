import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:khmerbiz_pos/core/theme/app_colors.dart';
import 'package:khmerbiz_pos/core/theme/app_spacing.dart';
import 'package:khmerbiz_pos/core/theme/app_text_styles.dart';
import 'package:khmerbiz_pos/domain/entities/inventory_log.dart';
import 'package:khmerbiz_pos/domain/entities/product.dart';
import 'package:khmerbiz_pos/features/inventory/presentation/bloc/inventory_bloc.dart';
import 'package:khmerbiz_pos/features/inventory/presentation/bloc/inventory_event.dart';
import 'package:khmerbiz_pos/features/inventory/presentation/bloc/inventory_state.dart';
import 'package:khmerbiz_pos/features/inventory/presentation/widgets/stock_adjustment_sheet.dart';
import 'package:khmerbiz_pos/shared/widgets/displays/stock_badge.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<InventoryBloc>().add(const LoadInventoryLog());
    context.read<InventoryBloc>().add(LoadLowStockReport());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          'Inventory',
          style:
              AppTextStyles.headlineLarge.copyWith(color: AppColors.primary),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.accent,
          tabs: const [
            Tab(text: 'Low Stock', icon: Icon(Icons.warning_amber)),
            Tab(text: 'Activity Log', icon: Icon(Icons.history)),
          ],
        ),
      ),
      body: BlocBuilder<InventoryBloc, InventoryState>(
        builder: (context, state) {
          return TabBarView(
            controller: _tabController,
            children: [
              _buildLowStockTab(state),
              _buildActivityLogTab(state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLowStockTab(InventoryState state) {
    if (state is InventoryLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is InventoryLoaded) {
      if (state.lowStockItems.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_outline,
                  size: 64, color: AppColors.success),
              const SizedBox(height: AppSpacing.base),
              Text('All products are well stocked!',
                  style: AppTextStyles.headlineMedium),
            ],
          ),
        );
      }
      return RefreshIndicator(
        onRefresh: () async {
          context.read<InventoryBloc>().add(LoadLowStockReport());
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
          itemCount: state.lowStockItems.length,
          itemBuilder: (context, index) {
            final product = state.lowStockItems[index];
            return _buildLowStockItem(product);
          },
        ),
      );
    }
    if (state is InventoryError) {
      return Center(child: Text('Error: ${state.failure}'));
    }
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildLowStockItem(Product product) {
    final stockStatus = product.stock <= 0
        ? StockStatus.outOfStock
        : StockStatus.lowStock;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        side: BorderSide(
          color: stockStatus == StockStatus.outOfStock
              ? AppColors.error.withValues(alpha: 0.3)
              : AppColors.warning.withValues(alpha: 0.3),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.base,
          vertical: AppSpacing.sm,
        ),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: stockStatus == StockStatus.outOfStock
                ? AppColors.errorLight
                : AppColors.warningLight,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
          ),
          child: Icon(
            stockStatus == StockStatus.outOfStock
                ? Icons.error_outline
                : Icons.warning_amber,
            color: stockStatus == StockStatus.outOfStock
                ? AppColors.error
                : AppColors.warning,
          ),
        ),
        title: Text(product.nameKh, style: AppTextStyles.labelMedium),
        subtitle: Text(
          '${product.nameEn} | Stock: ${product.stock.toStringAsFixed(0)} / Threshold: ${product.lowStockThreshold.toStringAsFixed(0)}',
          style: AppTextStyles.bodySmall
              .copyWith(color: AppColors.textSecondary),
        ),
        trailing: StockBadge(
          status: stockStatus,
          quantity: product.stock.toInt(),
          style: StockBadgeStyle.compact,
        ),
        onTap: () => StockAdjustmentSheet.show(context, product),
      ),
    );
  }

  Widget _buildActivityLogTab(InventoryState state) {
    if (state is InventoryLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is InventoryLoaded) {
      if (state.logs.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.history,
                  size: 64, color: AppColors.textTertiary),
              const SizedBox(height: AppSpacing.base),
              Text('No inventory activity yet',
                  style: AppTextStyles.headlineMedium),
            ],
          ),
        );
      }
      return RefreshIndicator(
        onRefresh: () async {
          context.read<InventoryBloc>().add(const LoadInventoryLog());
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
          itemCount: state.logs.length,
          itemBuilder: (context, index) {
            return _buildLogItem(state.logs[index]);
          },
        ),
      );
    }
    if (state is InventoryError) {
      return Center(child: Text('Error: ${state.failure}'));
    }
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildLogItem(InventoryLog log) {
    final isPositive = log.changeAmount > 0;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.base,
          vertical: AppSpacing.xs,
        ),
        leading: CircleAvatar(
          backgroundColor:
              isPositive ? AppColors.successLight : AppColors.errorLight,
          child: Icon(
            isPositive ? Icons.add : Icons.remove,
            color: isPositive ? AppColors.success : AppColors.error,
          ),
        ),
        title: Text(
          '${isPositive ? '+' : ''}${log.changeAmount.toStringAsFixed(0)} (${log.reason})',
          style: AppTextStyles.labelMedium.copyWith(
            color: isPositive ? AppColors.success : AppColors.error,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${log.stockBefore.toStringAsFixed(0)} → ${log.stockAfter.toStringAsFixed(0)}',
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColors.textSecondary),
            ),
            if (log.notes != null && log.notes!.isNotEmpty)
              Text(
                log.notes!,
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.textTertiary),
              ),
          ],
        ),
        trailing: Text(
          _formatTime(log.timestamp),
          style: AppTextStyles.bodySmall
              .copyWith(color: AppColors.textTertiary),
        ),
      ),
    );
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${date.day}/${date.month}/${date.year}';
  }
}

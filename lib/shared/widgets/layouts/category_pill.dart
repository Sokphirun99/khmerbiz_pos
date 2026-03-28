import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:khmerbiz_pos/core/theme/app_colors.dart';
import 'package:khmerbiz_pos/core/theme/app_spacing.dart';

/// Category data for CategoryPill
class CategoryPillData {

  const CategoryPillData({
    required this.id,
    required this.name,
    this.nameKhmer,
    this.icon,
    this.productCount,
  });
  final String id;
  final String name;
  final String? nameKhmer;
  final IconData? icon;
  final int? productCount;
}

/// KhmerBiz POS Category Pill
///
/// Horizontal scrollable category filter chip.
///
/// Features:
/// - Selected/unselected states
/// - Bilingual label (Khmer + English)
/// - Optional icon
/// - Optional product count
/// - Smooth animations
///
/// Usage:
/// ```dart
/// // Single pill
/// CategoryPill(
///   category: CategoryPillData(
///     id: '1',
///     name: 'Coffee',
///     nameKhmer: 'កាហ្វេ',
///     productCount: 12,
///   ),
///   isSelected: true,
///   onTap: () => _selectCategory('1'),
/// )
///
/// // Scrollable row
/// CategoryPillRow(
///   categories: categories,
///   selectedId: selectedCategoryId,
///   onSelected: (id) => _selectCategory(id),
/// )
/// ```
class CategoryPill extends StatefulWidget {

  const CategoryPill({
    required this.category, super.key,
    this.isSelected = false,
    this.onTap,
    this.showCount = true,
    this.height,
  });
  /// Category data
  final CategoryPillData category;

  /// Whether this category is selected
  final bool isSelected;

  /// Callback when pill is tapped
  final VoidCallback? onTap;

  /// Show product count
  final bool showCount;

  /// Pill height (default: 40dp)
  final double? height;

  @override
  State<CategoryPill> createState() => _CategoryPillState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<CategoryPillData>('category', category));
    properties.add(DiagnosticsProperty<bool>('isSelected', isSelected));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap));
    properties.add(DiagnosticsProperty<bool>('showCount', showCount));
    properties.add(DoubleProperty('height', height));
  }
}

class _CategoryPillState extends State<CategoryPill>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
    widget.onTap?.call();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final pillHeight = widget.height ?? AppSpacing.categoryPillHeight;

    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: pillHeight,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.categoryPillPadding,
            ),
            decoration: BoxDecoration(
              color: _getBackgroundColor(),
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              border: Border.all(
                color: _getBorderColor(),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon (if available)
                if (widget.category.icon != null) ...[
                  Icon(
                    widget.category.icon,
                    size: 18,
                    color: _getIconColor(),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                ],

                // Khmer name (primary)
                if (widget.category.nameKhmer != null)
                  Text(
                    widget.category.nameKhmer!,
                    style: TextStyle(
                      fontFamily: 'Kantumruy Pro',
                      fontSize: 14,
                      fontWeight: widget.isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      height: 1.4,
                      color: _getTextColor(),
                    ),
                  ),

                // English name
                if (widget.category.name.isNotEmpty) ...[
                  if (widget.category.nameKhmer != null)
                    const SizedBox(width: AppSpacing.xs),
                  Text(
                    widget.category.name,
                    style: TextStyle(
                      fontFamily: 'Kantumruy Pro',
                      fontSize: 13,
                      fontWeight: widget.isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      height: 1.4,
                      color: _getTextColor(),
                    ),
                  ),
                ],

                // Product count
                if (widget.showCount && widget.category.productCount != null) ...[
                  const SizedBox(width: AppSpacing.xs),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _getCountBackgroundColor(),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                    ),
                    child: Text(
                      '${widget.category.productCount}',
                      style: TextStyle(
                        fontFamily: 'Roboto Mono',
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: _getCountTextColor(),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    return widget.isSelected ? AppColors.primary : AppColors.surface;
  }

  Color _getBorderColor() {
    return widget.isSelected ? AppColors.primary : AppColors.border;
  }

  Color _getIconColor() {
    return widget.isSelected ? AppColors.onPrimary : AppColors.textSecondary;
  }

  Color _getTextColor() {
    return widget.isSelected ? AppColors.onPrimary : AppColors.textPrimary;
  }

  Color _getCountBackgroundColor() {
    return widget.isSelected
        ? AppColors.onPrimary.withOpacity(0.2)
        : AppColors.surfaceAlt;
  }

  Color _getCountTextColor() {
    return widget.isSelected ? AppColors.primary : AppColors.textSecondary;
  }
}

/// Scrollable row of category pills
class CategoryPillRow extends StatelessWidget {

  const CategoryPillRow({
    required this.categories, required this.onSelected, super.key,
    this.selectedId,
    this.showCount = true,
    this.pillHeight,
    this.padding,
    this.scrollController,
  });
  /// List of categories
  final List<CategoryPillData> categories;

  /// Currently selected category ID
  final String? selectedId;

  /// Callback when category is selected
  final ValueChanged<String> onSelected;

  /// Show product count
  final bool showCount;

  /// Pill height
  final double? pillHeight;

  /// Padding around the row
  final EdgeInsetsGeometry? padding;

  /// Scroll controller
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (pillHeight ?? AppSpacing.categoryPillHeight) + AppSpacing.sm * 2,
      padding: padding ??
          const EdgeInsets.symmetric(
            horizontal: AppSpacing.base,
            vertical: AppSpacing.sm,
          ),
      child: ListView.separated(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.xs),
        itemBuilder: (context, index) {
          final category = categories[index];
          return CategoryPill(
            category: category,
            isSelected: selectedId == category.id,
            onTap: () => onSelected(category.id),
            showCount: showCount,
            height: pillHeight,
          );
        },
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<CategoryPillData>('categories', categories));
    properties.add(StringProperty('selectedId', selectedId));
    properties.add(ObjectFlagProperty<ValueChanged<String>>.has('onSelected', onSelected));
    properties.add(DiagnosticsProperty<bool>('showCount', showCount));
    properties.add(DoubleProperty('pillHeight', pillHeight));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry?>('padding', padding));
    properties.add(DiagnosticsProperty<ScrollController?>('scrollController', scrollController));
  }
}

/// Category pill with all option
class CategoryPillRowWithAll extends StatelessWidget {

  const CategoryPillRowWithAll({
    required this.categories, required this.onSelected, super.key,
    this.selectedId,
    this.allLabel = 'All',
    this.allLabelKhmer,
    this.showCount = true,
  });
  final List<CategoryPillData> categories;
  final String? selectedId;
  final ValueChanged<String?> onSelected;
  final String allLabel;
  final String? allLabelKhmer;
  final bool showCount;

  @override
  Widget build(BuildContext context) {
    final allCategory = CategoryPillData(
      id: 'all',
      name: allLabel,
      nameKhmer: allLabelKhmer,
      icon: Icons.apps_outlined,
      productCount: showCount ? categories.fold<int>(0, (sum, c) => sum + (c.productCount ?? 0)) : null,
    );

    final allCategories = [allCategory, ...categories];

    return CategoryPillRow(
      categories: allCategories,
      selectedId: selectedId ?? 'all',
      onSelected: (id) => onSelected(id == 'all' ? null : id),
      showCount: showCount,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<CategoryPillData>('categories', categories));
    properties.add(StringProperty('selectedId', selectedId));
    properties.add(ObjectFlagProperty<ValueChanged<String?>>.has('onSelected', onSelected));
    properties.add(StringProperty('allLabel', allLabel));
    properties.add(StringProperty('allLabelKhmer', allLabelKhmer));
    properties.add(DiagnosticsProperty<bool>('showCount', showCount));
  }
}

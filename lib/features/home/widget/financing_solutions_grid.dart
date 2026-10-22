import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_skeleton.dart';
import '../models/financing_solution_model.dart';
import '../provider/home_provider.dart';

class FinancingSolutionsGrid extends ConsumerStatefulWidget {
  final ValueChanged<FinancingSolutionModel>? onCardSelected;

  const FinancingSolutionsGrid({super.key, this.onCardSelected});

  @override
  ConsumerState<FinancingSolutionsGrid> createState() =>
      _FinancingSolutionsGridState();
}

class _FinancingSolutionsGridState
    extends ConsumerState<FinancingSolutionsGrid> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final catalog = ref.watch(financingSolutionsProvider);
    return catalog.when(
      loading: () => const _FinancingSolutionsSkeleton(),
      error: (error, _) => _buildError(context, error),
      data: (data) => _buildCatalog(context, data),
    );
  }

  Widget _buildCatalog(
    BuildContext context,
    FinancingSolutionsCatalog catalog,
  ) {
    final initial = catalog.products
        .where((product) => product.visibleInitially)
        .toList();
    final visibleProducts = initial.isEmpty
        ? catalog.products.take(catalog.initialVisibleCount).toList()
        : initial;
    final displayed = _showAll ? catalog.products : visibleProducts;
    final additionalCount = catalog.products.length - visibleProducts.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context, displayed.length),
        const SizedBox(height: 12),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: displayed.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.35,
          ),
          itemBuilder: (context, index) => _buildProductCard(displayed[index]),
        ),
        if (additionalCount > 0) ...[
          const SizedBox(height: 12),
          Center(
            child: OutlinedButton.icon(
              onPressed: () => setState(() => _showAll = !_showAll),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryContainer,
                side: const BorderSide(color: AppColors.outlineVariant),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              icon: Icon(
                _showAll ? Icons.expand_less : Icons.expand_more,
                size: 18,
              ),
              label: Text(
                _showAll
                    ? context.tr('View Less')
                    : context.tr(
                        'View More Solutions ({count} more)',
                        args: {'count': additionalCount},
                      ),
                style: AppTypography.labelMd.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildHeader(BuildContext context, int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr('Financing Solutions'),
              style: AppTypography.headlineSm.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
            Text(
              context.tr('Pre-vetted lending pipelines'),
              style: AppTypography.caption.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: AppColors.secondaryFixed.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            context.tr('{count} Offerings', args: {'count': count}),
            style: AppTypography.caption.copyWith(
              color: AppColors.secondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(FinancingSolutionModel product) {
    final (badgeBackground, badgeForeground) = switch (product.badgeTone) {
      'success' => (const Color(0xFFECFDF5), const Color(0xFF059669)),
      'gold' => (const Color(0xFFFDFBF7), const Color(0xFF8C6D23)),
      'info' => (const Color(0xFFEFF6FF), const Color(0xFF1D4ED8)),
      _ => (AppColors.surfaceContainerLow, AppColors.onPrimaryFixedVariant),
    };

    return InkWell(
      onTap: product.applicationEnabled
          ? () => widget.onCardSelected?.call(product)
          : null,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.outlineVariant.withValues(alpha: 0.35),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      _fallbackIcon(product.fallbackIconKey),
                      size: 20,
                      color: AppColors.primaryContainer,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 1.5,
                      ),
                      decoration: BoxDecoration(
                        color: badgeBackground,
                        borderRadius: BorderRadius.circular(3),
                        border: Border.all(
                          color: badgeForeground.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        context.tr(product.badgeText),
                        style: AppTypography.caption.copyWith(
                          color: badgeForeground,
                          fontWeight: FontWeight.w700,
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  context.tr(product.title),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelMd.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                Text(
                  context.tr(product.amountLabel),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    context.tr(product.rateLabel),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  size: 14,
                  color: AppColors.outline,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, Object error) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            error.toString(),
            textAlign: TextAlign.center,
            style: AppTypography.bodySm.copyWith(color: AppColors.error),
          ),
          TextButton.icon(
            onPressed: () => ref.invalidate(financingSolutionsProvider),
            icon: const Icon(Icons.refresh),
            label: Text(context.tr('Retry')),
          ),
        ],
      ),
    );
  }

  IconData _fallbackIcon(String key) => switch (key) {
    'person' => Icons.person_outline,
    'business' => Icons.storefront_outlined,
    'home' => Icons.home_work_outlined,
    'vehicle' => Icons.directions_car_outlined,
    'property' => Icons.domain_outlined,
    'invoice' => Icons.receipt_long_outlined,
    'group' => Icons.groups_outlined,
    'shield' => Icons.health_and_safety_outlined,
    'insurance' => Icons.health_and_safety_outlined,
    _ => Icons.account_balance_outlined,
  };
}

class _FinancingSolutionsSkeleton extends StatelessWidget {
  const _FinancingSolutionsSkeleton();

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SkeletonBox(width: 170, height: 18),
          const SizedBox(height: 5),
          const SkeletonBox(width: 125, height: 10),
          const SizedBox(height: 12),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 6,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.35,
            ),
            itemBuilder: (_, _) => const SkeletonBox(height: 110),
          ),
        ],
      ),
    );
  }
}

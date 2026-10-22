import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_skeleton.dart';
import '../../home/provider/home_provider.dart';
import '../provider/loans_provider.dart';
import '../widget/loan_facility_card.dart';
import '../../../core/localization/app_localizations.dart';

/// Loans Screen placeholder with institutional design.
class LoansScreen extends ConsumerWidget {
  const LoansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loansState = ref.watch(loansProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('Active Facilities & History'),
            style: AppTypography.headlineLgMobile.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            context.tr(
              'Institutional credit portfolio and facility sanctions.',
            ),
            style: AppTypography.bodySm.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),

          if (loansState.isLoading && loansState.facilities.isEmpty)
            const _LoanFacilitiesSkeleton()
          else if (loansState.errorMessage != null &&
              loansState.facilities.isEmpty)
            _LoansError(
              message: loansState.errorMessage!,
              onRetry: () => ref.read(loansProvider.notifier).loadFacilities(),
            )
          else if (loansState.facilities.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  context.tr('No active loan facilities found.'),
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            )
          else
            ...loansState.facilities.map(
              (facility) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: LoanFacilityCard(facility: facility),
              ),
            ),
          const SizedBox(height: 10),

          // Apply new facility CTA card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.outlineVariant.withValues(alpha: 0.35),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.add_circle, color: AppColors.secondary),
                    const SizedBox(width: 8),
                    Text(
                      context.tr('Apply for Additional Line'),
                      style: AppTypography.headlineSm.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  context.tr(
                    'Pre-vetted institutional syndicate pipelines available with 4-hour sanctions.',
                  ),
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 14),
                AppButton(
                  text: context.tr('Explore New Credit Facility'),
                  variant: AppButtonVariant.secondary,
                  onPressed: () {
                    ref.read(selectedTabProvider.notifier).state = 0;
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LoanFacilitiesSkeleton extends StatelessWidget {
  const _LoanFacilitiesSkeleton();

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Container(
          height: 180,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SkeletonBox(width: 150, height: 12),
                  SkeletonBox(width: 70, height: 20, borderRadius: 4),
                ],
              ),
              SizedBox(height: 20),
              SkeletonBox(width: 170, height: 30),
              Spacer(),
              Divider(),
              SizedBox(height: 8),
              SkeletonBox(width: double.infinity, height: 14),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoansError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _LoansError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTypography.bodySm.copyWith(color: AppColors.error),
          ),
          TextButton(onPressed: onRetry, child: Text(context.tr('Retry'))),
        ],
      ),
    );
  }
}

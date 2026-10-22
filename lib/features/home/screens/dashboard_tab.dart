import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/app_skeleton.dart';
import '../../auth/provider/auth_provider.dart';
import '../provider/home_provider.dart';
import '../widget/hero_card.dart';
import '../widget/application_status_card.dart';
import '../widget/quick_actions_grid.dart';
import '../widget/financing_solutions_grid.dart';
import '../widget/trust_strip.dart';
import '../../../core/localization/app_localizations.dart';

/// Dashboard Tab matching Stitch specifications and user requirements.
///
/// Customizations applied per user requirements:
/// - ✅ REMOVED "CIBIL score" from welcome banner
/// - ✅ REMOVED "NBFC Partnered" badge from welcome banner
/// - ✅ REMOVED "Check Eligibility" from Quick Actions (leaving 3 items)
/// - ✅ Added "View More" option in Financing Solutions
class DashboardTab extends ConsumerWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final dashboard = ref.watch(dashboardProvider);
    final userName =
        dashboard.asData?.value.firstName ?? authState.userName ?? 'Rajesh';

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Welcome Header (Modified) ─────────────────────────────
          // Note: "NBFC Partnered" and "CIBIL score" have been REMOVED per user request.
          Container(
            padding: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.outlineVariant.withValues(alpha: 0.25),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          context.tr('Good morning, '),
                          style: AppTypography.bodySm.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          userName,
                          style: AppTypography.headlineSm.copyWith(
                            color: AppColors.onSurface,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(
                          Icons.verified_user,
                          size: 13,
                          color: AppColors.onTertiaryContainer,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          context.tr('Fiduciary Tier 1 Verified'),
                          style: AppTypography.caption.copyWith(
                            color: AppColors.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Security status badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: AppColors.outlineVariant.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.lock,
                        size: 12,
                        color: AppColors.secondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        context.tr('Secure Rail'),
                        style: AppTypography.caption.copyWith(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ─── Hero Section ──────────────────────────────────────────
          HeroCard(
            onExplore: () {
              AppSnackbar.showInfo(
                context,
                context.tr('Browsing verified institutional credit options...'),
              );
            },
          ),
          const SizedBox(height: 18),

          // ─── Active Application Status Card ────────────────────────
          dashboard.when(
            loading: () => const _ApplicationStatusSkeleton(),
            error: (_, _) => _DashboardRetry(
              onRetry: () => ref.invalidate(dashboardProvider),
            ),
            data: (data) => data.activeApplication == null
                ? const SizedBox.shrink()
                : ApplicationStatusCard(
                    application: data.activeApplication!,
                    onViewTracker: () {
                      AppSnackbar.showInfo(
                        context,
                        context.tr('Opening application tracker...'),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 18),

          // ─── Quick Actions (3 items) ───────────────────────────────
          QuickActionsGrid(
            onApplyNow: () {
              AppSnackbar.showInfo(
                context,
                context.tr('Starting fresh institutional loan application...'),
              );
            },
            onTrackApp: () {
              AppSnackbar.showInfo(
                context,
                context.tr('Tracking active application #ARH10294...'),
              );
            },
            onTalkToUs: () {
              AppSnackbar.showInfo(
                context,
                context.tr('Connecting with Arohya Fiduciary Desk...'),
              );
            },
          ),
          const SizedBox(height: 22),

          // ─── Financing Solutions (curated cards + View More) ───────
          FinancingSolutionsGrid(
            onCardSelected: (offering) {
              context.push(
                Uri(
                  path: '/apply-loan',
                  queryParameters: {'productId': offering.id},
                ).toString(),
              );
            },
          ),
          const SizedBox(height: 24),

          // ─── Trust Footer Strip ────────────────────────────────────
          const TrustStrip(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _ApplicationStatusSkeleton extends StatelessWidget {
  const _ApplicationStatusSkeleton();

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SkeletonBox(width: 34, height: 34),
                SizedBox(width: 10),
                Expanded(child: SkeletonBox(height: 16)),
              ],
            ),
            SizedBox(height: 18),
            SkeletonBox(height: 18),
            SizedBox(height: 12),
            SkeletonBox(height: 6),
            SizedBox(height: 16),
            SkeletonBox(width: 110, height: 12),
          ],
        ),
      ),
    );
  }
}

class _DashboardRetry extends StatelessWidget {
  final VoidCallback onRetry;

  const _DashboardRetry({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onRetry,
      icon: const Icon(Icons.refresh),
      label: Text(context.tr('Retry dashboard')),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/localization/locale_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/swipe_to_action_button.dart';
import '../models/onboarding_model.dart';
import '../widget/priority_corridor_card.dart';
import '../widget/expandable_value_props.dart';

/// Onboarding Screen matching the Arohya Sovereign FinTech design.
///
/// Features:
/// - Sticky top bar with brand mark, language pill, and skip action
/// - Priority Corridor Hero Card (Deep Navy with gold accents)
/// - Carousel indicators
/// - Value Proposition Bento Stack (RBI Regulated, Account Aggregator, KFS)
/// - Bottom sticky CTAs (Get Started / Create Account swipe, Sign In)
class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  static final List<ValuePropModel> _valueProps = [
    const ValuePropModel(
      icon: Icons.verified_outlined,
      iconBg: AppColors.surfaceContainer,
      iconColor: AppColors.primaryContainer,
      title: 'RBI Regulated Guidelines 2022 Compliant',
      subtitle:
          'Direct fiduciary adherence to digital lending protocols and safe custody mandates.',
    ),
    ValuePropModel(
      icon: Icons.bolt,
      iconBg: AppColors.secondaryFixed.withValues(alpha: 0.3),
      iconColor: AppColors.secondary,
      title: 'Account Aggregator Direct Integration',
      subtitle:
          'Encrypted zero-tamper GST and bank statements fetching in under 90 seconds.',
    ),
    ValuePropModel(
      icon: Icons.description_outlined,
      iconBg: AppColors.tertiaryFixed.withValues(alpha: 0.3),
      iconColor: AppColors.onTertiaryContainer,
      title: 'Transparent Key Fact Statements (KFS)',
      subtitle:
          'Zero concealed charges, upfront APR disclosure, and no prepayment penalties.',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isKannada =
        ref.watch(appLocaleProvider).languageCode ==
        AppLocalizations.kannada.languageCode;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            // ─── Top Header ──────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest.withValues(alpha: 0.9),
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.outlineVariant.withValues(alpha: 0.3),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Brand Mark
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: AppColors.secondaryContainer.withValues(
                              alpha: 0.4,
                            ),
                          ),
                        ),
                        child: const Icon(
                          Icons.account_balance,
                          size: 18,
                          color: AppColors.secondaryContainer,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'AROHYA',
                        style: AppTypography.headlineSm.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ],
                  ),

                  // Language Switcher & Skip Action
                  Row(
                    children: [
                      // Language Pill
                      InkWell(
                        onTap: () {
                          ref.read(appLocaleProvider.notifier).toggle();
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.outlineVariant.withValues(
                                alpha: 0.5,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.translate,
                                size: 14,
                                color: AppColors.secondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                isKannada
                                    ? 'ಕನ್ನಡ / English'
                                    : 'English / ಕನ್ನಡ',
                                style: AppTypography.labelSm.copyWith(
                                  color: AppColors.onSurface,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Skip Button
                      TextButton(
                        onPressed: () => context.push('/login'),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          context.tr('Skip'),
                          style: AppTypography.labelMd.copyWith(
                            color: AppColors.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ─── Scrollable Content ──────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Priority Corridor Hero Card
                    const PriorityCorridorCard(),
                    const SizedBox(height: 16),

                    // Carousel Indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 24,
                          height: 6,
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: AppColors.outlineVariant.withValues(
                              alpha: 0.6,
                            ),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: AppColors.outlineVariant.withValues(
                              alpha: 0.6,
                            ),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Narrative Section
                    Text(
                      context.tr('Sovereign Capital for Indian Enterprises'),
                      style: AppTypography.headlineLgMobile.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.tr('Fast-track institutional lending with zero hard credit bureau inquiries and algorithmic syndicate match within 4 hours.'),
                      style: AppTypography.bodyMd.copyWith(
                        color: AppColors.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Expandable "Read More" Trust & Regulatory Framework
                    ExpandableValueProps(valueProps: _valueProps),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // ─── Bottom Action Area ──────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                border: Border(
                  top: BorderSide(
                    color: AppColors.outlineVariant.withValues(alpha: 0.3),
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Primary CTA — swipe to get started
                  SwipeToActionButton(
                    text: context.tr('Get Started / Create Account'),
                    onCompleted: () => context.push('/signup'),
                  ),
                  const SizedBox(height: 10),

                  // Secondary CTA Link
                  InkWell(
                    onTap: () => context.push('/login'),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            context.tr('Already have an account? '),
                            style: AppTypography.labelMd.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            context.tr('Sign In'),
                            style: AppTypography.labelMd.copyWith(
                              color: AppColors.secondary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

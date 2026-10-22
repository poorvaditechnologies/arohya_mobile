import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/localization/app_localizations.dart';

/// Deep Navy hero card matching the Stitch Dashboard design.
class HeroCard extends StatelessWidget {
  final VoidCallback? onExplore;

  const HeroCard({super.key, this.onExplore});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.secondary.withValues(alpha: 0.35),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Ambient Gold Glow
          Positioned(
            right: -20,
            bottom: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondaryContainer.withValues(alpha: 0.1),
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.onPrimaryFixed.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: AppColors.secondary.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 5,
                      height: 5,
                      decoration: const BoxDecoration(
                        color: AppColors.secondaryFixed,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      context.tr('AROHYA FACILITATION'),
                      style: AppTypography.caption.copyWith(
                        color: AppColors.secondaryFixed,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Title & Subtitle
              Text(
                context.tr('What are you looking for?'),
                style: AppTypography.headlineLgMobile.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                context.tr('Your financial journey, simplified. Institutional credit structures tailored for growth.'),
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.onPrimaryContainer,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),

              // CTA Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: onExplore,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondaryContainer,
                      foregroundColor: AppColors.onSecondaryFixed,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            context.tr('Explore financing options'),
                            style: AppTypography.labelMd.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSecondaryFixed,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.arrow_forward,
                          size: 16,
                          color: AppColors.onSecondaryFixed,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Takes only the space left beside the button; wraps if tight.
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          context.tr('Multi-Lender Access'),
                          textAlign: TextAlign.end,
                          style: AppTypography.caption.copyWith(
                            color: AppColors.onPrimaryContainer,
                          ),
                        ),
                        Text(
                          context.tr('18+ Banking Partners'),
                          textAlign: TextAlign.end,
                          style: AppTypography.labelSm.copyWith(
                            color: AppColors.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

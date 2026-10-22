import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/localization/app_localizations.dart';

class PriorityCorridorCard extends StatelessWidget {
  const PriorityCorridorCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.secondaryContainer.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.secondaryContainer.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.secondaryContainer,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      context.tr('PRIORITY CORRIDOR'),
                      style: AppTypography.caption.copyWith(
                        color: AppColors.secondaryContainer,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.verified_user_outlined,
                size: 18,
                color: AppColors.outlineVariant,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            context.tr('PRE-APPROVED BUSINESS QUANTUM'),
            style: AppTypography.labelSm.copyWith(
              color: AppColors.outlineVariant,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                context.tr('up to '),
                style: AppTypography.headlineSm.copyWith(
                  color: AppColors.secondaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '₹50,00,000',
                style: AppTypography.financialNumeralLg.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            context.tr('Collateral-free credit facility with risk-adjusted underwriting'),
            style: AppTypography.caption.copyWith(
              color: AppColors.outlineVariant.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 16),
          Divider(
            color: AppColors.outlineVariant.withValues(alpha: 0.2),
            height: 1,
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

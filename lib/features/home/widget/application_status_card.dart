import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/localization/app_localizations.dart';
import '../models/home_model.dart';

/// Active Application Status card matching the Stitch Dashboard design.
class ApplicationStatusCard extends StatelessWidget {
  final ApplicationModel application;
  final VoidCallback? onViewTracker;

  const ApplicationStatusCard({
    super.key,
    required this.application,
    this.onViewTracker,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.business_center,
                      size: 18,
                      color: AppColors.primaryContainer,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.tr(
                          'APPLICATION #{number}',
                          args: {'number': application.applicationNumber},
                        ),
                        style: AppTypography.caption.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        context.tr(application.facilityName),
                        style: AppTypography.headlineSm.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Amber Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(color: const Color(0xFFFDE68A)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 5,
                      height: 5,
                      decoration: const BoxDecoration(
                        color: Color(0xFFB45309),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      context.tr(application.status),
                      style: AppTypography.caption.copyWith(
                        color: const Color(0xFFB45309),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Sanction Requested Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                context.tr('Sanction Requested'),
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              Text(
                '₹${_formatIndianAmount(application.requestedAmount)}',
                style: AppTypography.financialNumeralMd.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Progress Tracker
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.tr(
                  'Stage {current} of {total}',
                  args: {
                    'current': application.currentStep,
                    'total': application.totalSteps,
                  },
                ),
                style: AppTypography.caption.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              Text(
                '${(_progress * 100).round()}%',
                style: AppTypography.caption.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: _progress,
              minHeight: 6,
              backgroundColor: AppColors.surfaceContainerHigh,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.secondary,
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Card Footer
          Divider(
            color: AppColors.outlineVariant.withValues(alpha: 0.2),
            height: 1,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.tr('Updated today at 09:40 AM'),
                style: AppTypography.caption.copyWith(color: AppColors.outline),
              ),
              InkWell(
                onTap: onViewTracker,
                child: Row(
                  children: [
                    Text(
                      context.tr('View Tracker'),
                      style: AppTypography.labelMd.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  double get _progress => application.totalSteps <= 0
      ? 0
      : (application.currentStep / application.totalSteps)
            .clamp(0, 1)
            .toDouble();

  String _formatIndianAmount(double amount) {
    final digits = amount.round().toString();
    if (digits.length <= 3) return digits;
    final lastThree = digits.substring(digits.length - 3);
    final leading = digits.substring(0, digits.length - 3);
    final grouped = leading.replaceAllMapped(
      RegExp(r'\B(?=(\d{2})+(?!\d))'),
      (_) => ',',
    );
    return '$grouped,$lastThree';
  }
}

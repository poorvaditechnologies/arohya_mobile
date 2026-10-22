import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../models/loan_model.dart';
import '../../../core/localization/app_localizations.dart';

class LoanFacilityCard extends StatelessWidget {
  final LoanFacilityModel facility;

  const LoanFacilityCard({super.key, required this.facility});

  String _displayDate(String value) {
    final parsed = DateTime.tryParse(value);
    if (parsed == null) return value;
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${parsed.day} ${months[parsed.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.tr('TOTAL SANCTIONED CREDIT'),
                style: AppTypography.caption.copyWith(
                  color: AppColors.outlineVariant,
                  letterSpacing: 1.0,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.secondaryContainer.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  context.tr(
                    '{status} Facility',
                    args: {'status': context.tr(facility.status)},
                  ),
                  style: AppTypography.caption.copyWith(
                    color: AppColors.secondaryContainer,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '₹${facility.sanctionedAmount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d+?)(?=(\d\d)+(\d)(?!\d))'), (m) => '${m[1]},')}',
            style: AppTypography.financialNumeralLg.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Divider(color: Colors.white.withValues(alpha: 0.15)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.tr(
                  'Next EMI: {date} • ₹{amount}',
                  args: {
                    'date': _displayDate(facility.nextEmiDate),
                    'amount': facility.nextEmiAmount.toStringAsFixed(0),
                  },
                ),
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.outlineVariant,
                ),
              ),
              if (facility.autoDebitActive)
                Text(
                  context.tr('Auto-Debit Active'),
                  style: AppTypography.caption.copyWith(
                    color: AppColors.tertiaryFixed,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/localization/app_localizations.dart';

/// Bottom trust and regulatory accreditation footer.
class TrustStrip extends StatelessWidget {
  const TrustStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.outlineVariant.withValues(alpha: 0.25),
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.shield,
                size: 14,
                color: AppColors.secondary,
              ),
              const SizedBox(width: 6),
              Text(
                context.tr('Arohya Capital • Smart Financial Solutions'),
                style: AppTypography.caption.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            context.tr('Regulated under RBI Digital Lending Guidelines 2022 • 256-Bit SSL Encrypted'),
            textAlign: TextAlign.center,
            style: AppTypography.caption.copyWith(
              color: AppColors.outline,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

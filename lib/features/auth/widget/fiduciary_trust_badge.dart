import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/localization/app_localizations.dart';

class FiduciaryTrustBadge extends StatelessWidget {
  const FiduciaryTrustBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.lock, size: 12, color: AppColors.secondary),
          const SizedBox(width: 4),
          Text(
            context.tr('256-BIT SSL ENCRYPTED'),
            style: AppTypography.caption.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

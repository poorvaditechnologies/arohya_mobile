import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/localization/app_localizations.dart';

/// Quick actions row matching modified requirements.
///
/// Note: "Check Eligibility" has been REMOVED per user requirement, leaving 3 items:
/// - Apply Now
/// - Track App
/// - Talk to Us
class QuickActionsGrid extends StatelessWidget {
  final VoidCallback? onApplyNow;
  final VoidCallback? onTrackApp;
  final VoidCallback? onTalkToUs;

  const QuickActionsGrid({
    super.key,
    this.onApplyNow,
    this.onTrackApp,
    this.onTalkToUs,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.tr('Quick Actions'),
              style: AppTypography.headlineSm.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
            Text(
              context.tr('Direct Services'),
              style: AppTypography.caption.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                icon: Icons.edit_document,
                label: context.tr('Apply Now'),
                onTap: onApplyNow,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildActionCard(
                icon: Icons.radar,
                label: context.tr('Track App'),
                onTap: onTrackApp,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildActionCard(
                icon: Icons.support_agent,
                label: context.tr('Talk to Us'),
                onTap: onTalkToUs,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.outlineVariant.withValues(alpha: 0.35),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                icon,
                size: 20,
                color: AppColors.primaryContainer,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppTypography.labelSm.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/localization/app_localizations.dart';

class SplashEmblem extends StatelessWidget {
  const SplashEmblem({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Sovereign Geometric Crest Box
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primaryContainer,
                Color(0xFF060C15),
              ],
            ),
            border: Border.all(
              color: AppColors.secondary.withValues(alpha: 0.4),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: AppColors.secondaryContainer.withValues(alpha: 0.1),
                blurRadius: 24,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Inner Hairline Frame
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.secondaryContainer.withValues(alpha: 0.2),
                      ),
                    ),
                  ),
                ),
              ),
              // Gold Center Emblem
              const Icon(
                Icons.account_balance,
                size: 38,
                color: AppColors.secondaryContainer,
              ),
              // Corner Sovereign Anchors
              Positioned(
                top: 6,
                left: 6,
                child: Container(
                  width: 3,
                  height: 3,
                  color: AppColors.secondaryContainer.withValues(alpha: 0.7),
                ),
              ),
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  width: 3,
                  height: 3,
                  color: AppColors.secondaryContainer.withValues(alpha: 0.7),
                ),
              ),
              Positioned(
                bottom: 6,
                left: 6,
                child: Container(
                  width: 3,
                  height: 3,
                  color: AppColors.secondaryContainer.withValues(alpha: 0.7),
                ),
              ),
              Positioned(
                bottom: 6,
                right: 6,
                child: Container(
                  width: 3,
                  height: 3,
                  color: AppColors.secondaryContainer.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Brand Identity Typography
        Text(
          'AROHYA CAPITAL',
          style: AppTypography.displayLgMobile.copyWith(
            color: AppColors.onPrimary,
            letterSpacing: 4.0,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),

        // Subtle Gold Gradient Divider
        Container(
          height: 2,
          width: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1),
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                AppColors.secondaryContainer.withValues(alpha: 0.8),
                Colors.transparent,
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Institutional Subtitle
        Text(
          context.tr('SOVEREIGN SYNDICATE ARCHITECTURE'),
          style: AppTypography.labelSm.copyWith(
            color: AppColors.outlineVariant,
            letterSpacing: 2.2,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

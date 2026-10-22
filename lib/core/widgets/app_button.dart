import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Reusable button widget with 4 variants matching the Arohya design system.
///
/// Variants:
/// - **primary** — Deep navy fill, white text (main CTAs)
/// - **secondary** — Outlined with subtle border
/// - **ghost** — Text-only button
/// - **google** — Google sign-in styled button
enum AppButtonVariant { primary, secondary, ghost, google }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final bool isExpanded;
  final IconData? icon;
  final Widget? prefixWidget;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.isExpanded = true,
    this.icon,
    this.prefixWidget,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isExpanded ? double.infinity : null,
      height: 52,
      child: switch (variant) {
        AppButtonVariant.primary => _buildPrimary(),
        AppButtonVariant.secondary => _buildSecondary(),
        AppButtonVariant.ghost => _buildGhost(),
        AppButtonVariant.google => _buildGoogle(),
      },
    );
  }

  Widget _buildPrimary() {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryContainer,
        foregroundColor: AppColors.onPrimary,
        disabledBackgroundColor: AppColors.primaryContainer.withValues(alpha: 0.5),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: AppTypography.labelMd.copyWith(fontWeight: FontWeight.w600),
      ),
      child: _buildChild(AppColors.onPrimary),
    );
  }

  Widget _buildSecondary() {
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.onSurface,
        side: const BorderSide(color: AppColors.outlineVariant, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: AppTypography.labelMd.copyWith(fontWeight: FontWeight.w600),
      ),
      child: _buildChild(AppColors.onSurface),
    );
  }

  Widget _buildGhost() {
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: AppTypography.labelMd.copyWith(fontWeight: FontWeight.w500),
      ),
      child: _buildChild(AppColors.primary),
    );
  }

  Widget _buildGoogle() {
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.onSurface,
        backgroundColor: AppColors.surfaceContainerLowest,
        side: const BorderSide(color: AppColors.outlineVariant, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildGoogleLogo(),
          const SizedBox(width: 10),
          Text(
            text,
            style: AppTypography.labelMd.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  /// Renders the Google logo from SVG asset.
  Widget _buildGoogleLogo() {
    return SvgPicture.asset(
      'assets/search.svg',
      width: 20,
      height: 20,
    );
  }

  Widget _buildChild(Color color) {
    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2, color: color),
      );
    }

    if (icon != null || prefixWidget != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (prefixWidget != null) ...[prefixWidget!, const SizedBox(width: 8)],
          if (icon != null) ...[Icon(icon, size: 18), const SizedBox(width: 8)],
          Flexible(child: Text(text)),
        ],
      );
    }

    return Text(text);
  }
}

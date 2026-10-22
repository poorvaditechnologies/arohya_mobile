import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Utility class for showing floating snackbar notifications.
///
/// Provides 4 types: success, error, warning, info — each with
/// distinct colors and icons matching the Arohya design system.
enum SnackbarType { success, error, warning, info }

class AppSnackbar {
  AppSnackbar._();

  static void showSuccess(BuildContext context, String message) {
    show(context, message: message, type: SnackbarType.success);
  }

  static void showError(BuildContext context, String message) {
    show(context, message: message, type: SnackbarType.error);
  }

  static void showWarning(BuildContext context, String message) {
    show(context, message: message, type: SnackbarType.warning);
  }

  static void showInfo(BuildContext context, String message) {
    show(context, message: message, type: SnackbarType.info);
  }

  static void show(
    BuildContext context, {
    required String message,
    SnackbarType type = SnackbarType.info,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final (bgColor, iconData, iconColor) = switch (type) {
      SnackbarType.success => (
          AppColors.successBg,
          Icons.check_circle_rounded,
          AppColors.success,
        ),
      SnackbarType.error => (
          AppColors.errorContainer,
          Icons.error_rounded,
          AppColors.error,
        ),
      SnackbarType.warning => (
          AppColors.warningBg,
          Icons.warning_rounded,
          AppColors.warning,
        ),
      SnackbarType.info => (
          AppColors.surfaceContainer,
          Icons.info_rounded,
          AppColors.primaryContainer,
        ),
    };

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: bgColor,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: iconColor.withValues(alpha: 0.3)),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        duration: duration,
        content: Row(
          children: [
            Icon(iconData, color: iconColor, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: AppTypography.bodyMd.copyWith(
                  color: AppColors.onSurface,
                ),
              ),
            ),
          ],
        ),
        action: actionLabel != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: iconColor,
                onPressed: onAction ?? () {},
              )
            : null,
      ),
    );
  }
}

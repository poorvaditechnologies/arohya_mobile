import 'package:flutter/material.dart';

/// Centralized color palette for the Arohya Capital app.
/// Extracted from the Stitch "Arohya Sovereign FinTech" design system.
///
/// Usage: `AppColors.primaryContainer` — never hardcode hex values elsewhere.
class AppColors {
  AppColors._();

  // ─── Primary ─────────────────────────────────────────────
  static const Color primary = Color(0xFF000000);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF0E1C2F);
  static const Color onPrimaryContainer = Color(0xFF77849C);

  // ─── Primary Fixed ───────────────────────────────────────
  static const Color primaryFixed = Color(0xFFD6E3FE);
  static const Color primaryFixedDim = Color(0xFFBAC7E1);
  static const Color onPrimaryFixed = Color(0xFF0E1C2F);
  static const Color onPrimaryFixedVariant = Color(0xFF3A475C);

  // ─── Secondary (Warm Gold) ───────────────────────────────
  static const Color secondary = Color(0xFF775A19);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFFED488);
  static const Color onSecondaryContainer = Color(0xFF785A1A);
  static const Color secondaryFixed = Color(0xFFFFDEA5);
  static const Color secondaryFixedDim = Color(0xFFE9C176);
  static const Color onSecondaryFixed = Color(0xFF261900);
  static const Color onSecondaryFixedVariant = Color(0xFF5D4201);

  // ─── Tertiary (Emerald) ──────────────────────────────────
  static const Color tertiary = Color(0xFF000000);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFF002114);
  static const Color onTertiaryContainer = Color(0xFF069669);
  static const Color tertiaryFixed = Color(0xFF85F8C4);
  static const Color tertiaryFixedDim = Color(0xFF68DBA9);
  static const Color onTertiaryFixed = Color(0xFF002114);
  static const Color onTertiaryFixedVariant = Color(0xFF005137);

  // ─── Surface Hierarchy ───────────────────────────────────
  static const Color surface = Color(0xFFFAF8FF);
  static const Color surfaceDim = Color(0xFFD2D9F4);
  static const Color surfaceBright = Color(0xFFFAF8FF);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF2F3FF);
  static const Color surfaceContainer = Color(0xFFEAEDFF);
  static const Color surfaceContainerHigh = Color(0xFFE2E7FF);
  static const Color surfaceContainerHighest = Color(0xFFDAE2FD);
  static const Color surfaceVariant = Color(0xFFDAE2FD);
  static const Color surfaceTint = Color(0xFF525F75);

  // ─── On Surface ──────────────────────────────────────────
  static const Color onSurface = Color(0xFF131B2E);
  static const Color onSurfaceVariant = Color(0xFF44474C);

  // ─── Background ──────────────────────────────────────────
  static const Color background = Color(0xFFFAF8FF);
  static const Color onBackground = Color(0xFF131B2E);

  // ─── Inverse ─────────────────────────────────────────────
  static const Color inverseSurface = Color(0xFF283044);
  static const Color inverseOnSurface = Color(0xFFEEF0FF);
  static const Color inversePrimary = Color(0xFFBAC7E1);

  // ─── Outline ─────────────────────────────────────────────
  static const Color outline = Color(0xFF75777D);
  static const Color outlineVariant = Color(0xFFC5C6CD);

  // ─── Error ───────────────────────────────────────────────
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);

  // ─── Semantic / Functional Colors ────────────────────────
  static const Color success = Color(0xFF059669);
  static const Color successBg = Color(0xFFECFDF5);
  static const Color successBorder = Color(0xFFA7F3D0);

  static const Color warning = Color(0xFFB45309);
  static const Color warningBg = Color(0xFFFFFBEB);
  static const Color warningBorder = Color(0xFFFDE68A);

  static const Color goldTier = Color(0xFF8C6D23);
  static const Color goldTierBg = Color(0xFFFDFBF7);
  static const Color goldTierBorder = Color(0xFFEAD5A8);

  // ─── Google Brand ────────────────────────────────────────
  static const Color googleBlue = Color(0xFF4285F4);
  static const Color googleRed = Color(0xFFEA4335);
  static const Color googleYellow = Color(0xFFFBBC05);
  static const Color googleGreen = Color(0xFF34A853);
}

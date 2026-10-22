import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralized typography styles for the Arohya Capital app.
///
/// Follows the Stitch "Arohya Sovereign FinTech" type scale:
/// - **Manrope**: Headlines, display, financial numerals
/// - **Inter**: Body, labels, captions
///
/// Usage: `AppTypography.headlineSm.copyWith(color: AppColors.onSurface)`
class AppTypography {
  AppTypography._();

  // ─── Display (Manrope) ───────────────────────────────────
  static TextStyle get displayLg => GoogleFonts.manrope(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        height: 48 / 40,
        letterSpacing: -0.8,
      );

  static TextStyle get displayLgMobile => GoogleFonts.manrope(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        height: 38 / 30,
        letterSpacing: -0.6,
      );

  // ─── Headline (Manrope) ──────────────────────────────────
  static TextStyle get headlineLg => GoogleFonts.manrope(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 36 / 28,
        letterSpacing: -0.42,
      );

  static TextStyle get headlineLgMobile => GoogleFonts.manrope(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 28 / 22,
        letterSpacing: -0.22,
      );

  static TextStyle get headlineMd => GoogleFonts.manrope(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 28 / 20,
        letterSpacing: -0.2,
      );

  static TextStyle get headlineSm => GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 24 / 16,
      );

  // ─── Financial Numerals (Manrope) ────────────────────────
  static TextStyle get financialNumeralLg => GoogleFonts.manrope(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 38 / 32,
        letterSpacing: -0.64,
      );

  static TextStyle get financialNumeralMd => GoogleFonts.manrope(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 28 / 22,
        letterSpacing: -0.22,
      );

  // ─── Body (Inter) ────────────────────────────────────────
  static TextStyle get bodyLg => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 26 / 16,
      );

  static TextStyle get bodyMd => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 22 / 14,
      );

  static TextStyle get bodySm => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 18 / 12,
      );

  // ─── Label (Inter) ───────────────────────────────────────
  static TextStyle get labelMd => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        height: 18 / 13,
        letterSpacing: 0.13,
      );

  static TextStyle get labelSm => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        height: 16 / 11,
        letterSpacing: 0.44,
      );

  // ─── Caption (Inter) ─────────────────────────────────────
  static TextStyle get caption => GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        height: 14 / 10,
        letterSpacing: 0.2,
      );
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../provider/splash_provider.dart';
import '../widget/splash_emblem.dart';
import '../../../core/localization/app_localizations.dart';

/// Splash Screen matching the Stitch "Arohya Sovereign FinTech" design.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  Timer? _telemetryTimer;
  Timer? _navTimer;

  @override
  void initState() {
    super.initState();

    _telemetryTimer = Timer.periodic(const Duration(milliseconds: 1200), (
      timer,
    ) {
      if (mounted) {
        ref.read(splashProvider.notifier).advanceTelemetry();
      }
    });

    _navTimer = Timer(const Duration(milliseconds: 3200), () {
      if (mounted) {
        context.go('/onboarding');
      }
    });
  }

  @override
  void dispose() {
    _telemetryTimer?.cancel();
    _navTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final splashState = ref.watch(splashProvider);

    return Scaffold(
      backgroundColor: AppColors.primaryContainer,
      body: SafeArea(
        child: Stack(
          children: [
            // Atmospheric Architectural Lines & Glow
            Positioned.fill(
              child: Opacity(
                opacity: 0.15,
                child: CustomPaint(painter: _BackgroundGridPainter()),
              ),
            ),

            Column(
              children: [
                // ─── Header: Protocol Metadata ────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: AppColors.outlineVariant.withValues(
                            alpha: 0.15,
                          ),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.verified_user,
                              size: 14,
                              color: AppColors.secondaryContainer,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'AROHYA GATEWAY',
                              style: AppTypography.labelSm.copyWith(
                                color: AppColors.secondaryContainer,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'V1.0',
                          style: AppTypography.labelSm.copyWith(
                            color: AppColors.onPrimaryContainer,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ─── Center: Pinnacle Brand Showcase ──────────────────
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SplashEmblem(),
                      const SizedBox(height: 10),

                      // Institutional Subtitle
                      // Text(
                      //   'Sovereign Credit & Institutional Syndication',
                      //   textAlign: TextAlign.center,
                      //   style: AppTypography.labelMd.copyWith(
                      //     color: AppColors.secondaryContainer,
                      //     letterSpacing: 0.5,
                      //     fontWeight: FontWeight.w500,
                      //   ),
                      // ),
                      // const SizedBox(height: 28),

                      // Regulatory Governance Badge
                      // Container(
                      //   padding: const EdgeInsets.symmetric(
                      //     horizontal: 14,
                      //     vertical: 7,
                      //   ),
                      //   decoration: BoxDecoration(
                      //     color: AppColors.primaryContainer.withValues(
                      //       alpha: 0.8,
                      //     ),
                      //     borderRadius: BorderRadius.circular(4),
                      //     border: Border.all(
                      //       color: AppColors.secondary.withValues(alpha: 0.35),
                      //     ),
                      //   ),
                      //   child: Row(
                      //     mainAxisSize: MainAxisSize.min,
                      //     children: [
                      //       const Icon(
                      //         Icons.lock_outline,
                      //         size: 14,
                      //         color: AppColors.secondaryContainer,
                      //       ),
                      //       const SizedBox(width: 8),
                      //       Text(
                      //         'Regulated under RBI Digital Lending Directives',
                      //         style: AppTypography.caption.copyWith(
                      //           color: const Color(0xFFCBD5E1),
                      //           letterSpacing: 0.3,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),

                // ─── Footer: Telemetry Loading System ────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 24,
                  ),
                  child: Column(
                    children: [
                      // Status Label + Bit-Rate
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: AppColors.tertiaryFixed,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: Text(context.tr(splashState.currentMessage),
                                  key: ValueKey<int>(splashState.currentIndex),
                                  style: AppTypography.caption.copyWith(
                                    color: const Color(0xFF94A3B8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Text(
                          //   '256-BIT',
                          //   style: AppTypography.labelSm.copyWith(
                          //     color: AppColors.secondaryContainer,
                          //     fontWeight: FontWeight.bold,
                          //     letterSpacing: 1.0,
                          //   ),
                          // ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Sleek Gold Shimmer Loading Line
                      Container(
                        height: 2.5,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.outlineVariant.withValues(
                            alpha: 0.2,
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Shimmer.fromColors(
                          baseColor: Colors.transparent,
                          highlightColor: AppColors.secondaryContainer,
                          period: const Duration(milliseconds: 1800),
                          child: Container(
                            height: 2.5,
                            decoration: BoxDecoration(
                              color: AppColors.secondaryContainer,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Statutory Trust Footer
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Icon(
                      //       Icons.shield_outlined,
                      //       size: 13,
                      //       color: AppColors.secondaryContainer.withValues(
                      //         alpha: 0.9,
                      //       ),
                      //     ),
                      //     const SizedBox(width: 6),
                      //     // Text(
                      //     //   '256-Bit Bank-Grade Security • Fiduciary Discretion',
                      //     //   style: AppTypography.caption.copyWith(
                      //     //     color: AppColors.onPrimaryContainer,
                      //     //   ),s
                      //     // ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom painter for subtle architectural coordinate grid lines
class _BackgroundGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.secondaryContainer.withValues(alpha: 0.2)
      ..strokeWidth = 1.0;

    canvas.drawLine(const Offset(48, 0), Offset(48, size.height), paint);

    canvas.drawLine(
      Offset(size.width - 48, 0),
      Offset(size.width - 48, size.height),
      paint,
    );

    canvas.drawLine(
      Offset(0, size.height * 0.35),
      Offset(size.width, size.height * 0.35),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

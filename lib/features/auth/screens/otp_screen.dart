import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/swipe_to_action_button.dart';
import '../models/auth_model.dart';
import '../provider/auth_provider.dart';
import '../provider/otp_provider.dart';
import '../widget/otp_input_field.dart';
import '../../../core/localization/app_localizations.dart';

/// Email OTP verification screen — the second step of borrower signup.
///
/// Features:
/// - Six single-digit boxes (see [OtpInputField])
/// - Shake + error message on a wrong code, bounce on the right one
/// - Resend countdown
/// - Swipe-to-confirm CTA: "Register & Verify OTP" creates the account after
///   signup, "Verify & Sign In" logs the user in after login
class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen>
    with SingleTickerProviderStateMixin {
  final _otpKey = GlobalKey<OtpInputFieldState>();
  final _otpController = TextEditingController();
  final _otpFocus = FocusNode();

  late final AnimationController _entrance = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  Timer? _resendTimer;
  int _resendSecondsLeft = OtpNotifier.resendCooldownSeconds;

  String? _errorMessage;
  bool _isSuccess = false;
  bool _isBusy = false;

  @override
  void initState() {
    super.initState();
    _entrance.forward();
    _startResendCountdown();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      // Reached without a code request (e.g. deep link) — start over.
      final otpState = ref.read(otpProvider);
      if (otpState.email.isEmpty) {
        context.go(_originRoute(otpState.purpose));
        return;
      }
      _otpFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    _entrance.dispose();
    _otpController.dispose();
    _otpFocus.dispose();
    super.dispose();
  }

  /// Restarts the cooldown. Call inside `setState` (or `initState`).
  void _startResendCountdown() {
    _resendTimer?.cancel();
    _resendSecondsLeft = ref.read(otpProvider).resendAfterSeconds;
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_resendSecondsLeft <= 1) {
        timer.cancel();
      }
      setState(() => _resendSecondsLeft = _resendSecondsLeft - 1);
    });
  }

  void _resetEntry() {
    _otpController.clear();
    _errorMessage = null;
    _isSuccess = false;
  }

  Future<void> _handleResend() async {
    if (_isBusy) return;
    setState(_resetEntry);
    try {
      await ref.read(otpProvider.notifier).resend();
      if (!mounted) return;
      setState(_startResendCountdown);
      _otpFocus.requestFocus();
      AppSnackbar.showInfo(
        context,
        context.tr('A new verification code has been sent'),
      );
    } catch (error) {
      if (!mounted) return;
      AppSnackbar.showError(context, error.toString());
    }
  }

  /// Screen the user came from, used as the fallback for "back".
  String _originRoute(OtpPurpose purpose) =>
      purpose == OtpPurpose.login ? '/login' : '/signup';

  void _goBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(_originRoute(ref.read(otpProvider).purpose));
    }
  }

  Future<void> _handleVerify() async {
    if (_isBusy) return;
    final otpState = ref.read(otpProvider);
    if (otpState.email.isEmpty) return;

    final code = _otpController.text;
    if (code.length < OtpNotifier.length) {
      setState(() => _errorMessage = 'Enter the complete 6-digit code');
      await _otpKey.currentState?.shake();
      return;
    }

    setState(() {
      _isBusy = true;
      _errorMessage = null;
    });
    _otpFocus.unfocus();

    final isLogin = otpState.purpose == OtpPurpose.login;
    final pending = otpState.pending;
    try {
      ref.read(otpProvider.notifier).markVerifying();
      final auth = ref.read(authProvider.notifier);
      if (isLogin || pending == null) {
        await auth.loginWithOtp(
          email: otpState.email,
          otp: code,
          otpRequestId: otpState.otpRequestId,
          rememberDevice: ref.read(rememberDeviceProvider),
        );
      } else {
        await auth.signup(
          fullName: pending.fullName,
          email: pending.email,
          pan: pending.pan,
          entityType: pending.entityType,
          advisorCode: pending.advisorCode,
          otp: code,
          otpRequestId: otpState.otpRequestId,
        );
      }
      if (!mounted) return;
      ref.read(otpProvider.notifier).markVerified();
      setState(() => _isSuccess = true);
      await _otpKey.currentState?.playSuccess();
      if (!mounted) return;
      ref.read(otpProvider.notifier).reset();
      AppSnackbar.showSuccess(
        context,
        isLogin
            ? context.tr('Authentication successful. Welcome back!')
            : context.tr('Account created! Welcome to Arohya Capital.'),
      );
      context.go('/home');
    } catch (e) {
      if (!mounted) return;
      ref.read(otpProvider.notifier).markFailed();
      setState(() {
        _isBusy = false;
        _otpController.clear();
        _isSuccess = false;
        _errorMessage = e.toString();
      });
      await _otpKey.currentState?.shake();
      if (!mounted) return;
      _otpFocus.requestFocus();
      AppSnackbar.showError(
        context,
        isLogin
            ? context.tr('Login failed: {error}', args: {'error': e})
            : context.tr('Registration failed: {error}', args: {'error': e}),
      );
    }
  }

  /// "rajesh.gowda@example.com" → "ra***@example.com"
  String _maskEmail(String email) {
    final at = email.indexOf('@');
    if (at <= 0) return email;
    final local = email.substring(0, at);
    final visible = local.length <= 2
        ? local.substring(0, 1)
        : local.substring(0, 2);
    return '$visible***${email.substring(at)}';
  }

  /// Fades and slides [child] up, starting at [order] * 0.1 of the timeline.
  Widget _staggered(int order, Widget child) {
    final start = (order * 0.1).clamp(0.0, 0.5);
    final animation = CurvedAnimation(
      parent: _entrance,
      curve: Interval(start, start + 0.5, curve: Curves.easeOutCubic),
    );
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.15),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final otpState = ref.watch(otpProvider);
    final email = otpState.email;
    final isLogin = otpState.purpose == OtpPurpose.login;
    final isResending = otpState.status == OtpStatus.sending;
    final canResend = _resendSecondsLeft <= 0 && !isResending && !_isBusy;
    final hasError = _errorMessage != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ─── Top Bar Navigation ──────────────────────────────────
            Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.outlineVariant.withValues(alpha: 0.3),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    color: AppColors.onSurface,
                    onPressed: _isBusy ? null : _goBack,
                  ),
                  Text(
                    'AROHYA CAPITAL',
                    style: AppTypography.headlineSm.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                      color: AppColors.primaryContainer,
                    ),
                  ),
                ],
              ),
            ),

            // ─── Content ─────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 28,
                ),
                child: Column(
                  children: [
                    // Mail badge — pops in with a springy scale
                    _staggered(
                      0,
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.4, end: 1),
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.elasticOut,
                        builder: (context, scale, child) =>
                            Transform.scale(scale: scale, child: child),
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: AppColors.secondaryContainer.withValues(
                                alpha: 0.5,
                              ),
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.mark_email_unread_outlined,
                            size: 34,
                            color: AppColors.secondaryContainer,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),

                    _staggered(
                      1,
                      Text(
                        context.tr('Verify Your Email'),
                        textAlign: TextAlign.center,
                        style: AppTypography.headlineLgMobile.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    _staggered(
                      2,
                      Text.rich(
                        textAlign: TextAlign.center,
                        TextSpan(
                          style: AppTypography.bodyMd.copyWith(
                            color: AppColors.onSurfaceVariant,
                            height: 1.5,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  '${context.tr('Enter the 6-digit code we sent to')}\n',
                            ),
                            TextSpan(
                              text: _maskEmail(email),
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppColors.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // OTP boxes
                    OtpInputField(
                      key: _otpKey,
                      controller: _otpController,
                      focusNode: _otpFocus,
                      length: OtpNotifier.length,
                      hasError: hasError,
                      isSuccess: _isSuccess,
                      enabled: !_isBusy,
                      onChanged: (_) {
                        if (_errorMessage != null) {
                          setState(() => _errorMessage = null);
                        }
                      },
                      // Hide the keyboard so the swipe button is reachable.
                      onCompleted: (_) => _otpFocus.unfocus(),
                    ),

                    // Inline error — slides open under the boxes
                    AnimatedSize(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOut,
                      alignment: Alignment.topCenter,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 220),
                        child: hasError
                            ? Padding(
                                key: ValueKey(_errorMessage),
                                padding: const EdgeInsets.only(top: 14),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.error_rounded,
                                      size: 16,
                                      color: AppColors.error,
                                    ),
                                    const SizedBox(width: 6),
                                    Flexible(
                                      child: Text(
                                        context.tr(_errorMessage!),
                                        style: AppTypography.labelMd.copyWith(
                                          color: AppColors.error,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox(width: double.infinity),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Resend row
                    _staggered(
                      3,
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            context.tr("Didn't receive the code? "),
                            style: AppTypography.labelMd.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                          if (isResending)
                            const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          else if (canResend)
                            InkWell(
                              onTap: _handleResend,
                              child: Text(
                                context.tr('Resend code'),
                                style: AppTypography.labelMd.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            )
                          else
                            Text(
                              context.tr(
                                'Resend in {time}',
                                args: {
                                  'time':
                                      '0:${_resendSecondsLeft.clamp(0, 99).toString().padLeft(2, '0')}',
                                },
                              ),
                              style: AppTypography.labelMd.copyWith(
                                color: AppColors.outline,
                                fontWeight: FontWeight.w600,
                                fontFeatures: const [
                                  FontFeature.tabularFigures(),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Primary CTA
                    _staggered(
                      4,
                      SwipeToActionButton(
                        text: isLogin
                            ? context.tr('Verify & Sign In')
                            : context.tr('Register & Verify OTP'),
                        isLoading: _isBusy,
                        onCompleted: _handleVerify,
                      ),
                    ),
                    const SizedBox(height: 14),

                    _staggered(
                      5,
                      TextButton(
                        onPressed: _isBusy ? null : _goBack,
                        child: Text(
                          context.tr('Change email address'),
                          style: AppTypography.labelMd.copyWith(
                            color: AppColors.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

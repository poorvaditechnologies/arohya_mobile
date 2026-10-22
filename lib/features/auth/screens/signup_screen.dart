import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/app_text_field.dart';
import '../models/auth_model.dart';
import '../provider/auth_provider.dart';
import '../provider/otp_provider.dart';
import '../../../core/localization/app_localizations.dart';

/// Sign Up Screen matching Image 3 / Stitch Signup design.
///
/// Features:
/// - Header with "C-KYC READY" tag
/// - Legal Name, Email, PAN fields
/// - DPDP & RBI Fair Practice Consent checkboxes
/// - Primary CTA ("Continue") that emails an OTP and opens the OTP screen,
///   where the account is registered
/// - Google Sign Up button
class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _nameController = TextEditingController(text: 'Rajesh Kumar Gowda');
  final _emailController = TextEditingController(
    text: 'rajesh.gowda@example.com',
  );
  final _panController = TextEditingController(text: 'ABCDE1234F');
  final _advisorController = TextEditingController();

  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _panController.dispose();
    _advisorController.dispose();
    super.dispose();
  }

  Future<void> _handleContinue() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final pan = _panController.text.trim();
    final formState = ref.read(signupFormProvider);

    if (name.isEmpty) {
      AppSnackbar.showError(
        context,
        context.tr('Please enter your full legal name'),
      );
      return;
    }
    if (!_emailPattern.hasMatch(email)) {
      AppSnackbar.showError(
        context,
        context.tr('Please enter a valid email address'),
      );
      return;
    }
    if (pan.length != 10) {
      AppSnackbar.showError(
        context,
        context.tr('Please enter a valid 10-digit PAN number'),
      );
      return;
    }
    if (!formState.consentTerms || !formState.consentBureau) {
      AppSnackbar.showWarning(
        context,
        context.tr('Please accept the statutory consent items to proceed'),
      );
      return;
    }

    try {
      await ref
          .read(otpProvider.notifier)
          .sendOtp(
            PendingSignup(
              fullName: name,
              email: email,
              pan: pan,
              entityType: formState.entityType,
              advisorCode: _advisorController.text.trim().isEmpty
                  ? null
                  : _advisorController.text.trim(),
            ),
          );
      if (mounted) {
        AppSnackbar.showInfo(
          context,
          context.tr(
            'Verification code sent to {email}',
            args: {'email': email},
          ),
        );
        context.push('/verify-otp');
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.showError(
          context,
          context.tr(
            'Could not send verification code: {error}',
            args: {'error': e},
          ),
        );
      }
    }
  }

  Future<void> _handleGoogleSignup() async {
    try {
      await ref.read(authProvider.notifier).loginWithGoogle();
      if (mounted) {
        AppSnackbar.showSuccess(
          context,
          context.tr('Google account linked. Welcome Rajesh!'),
        );
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.showError(context, context.tr('Google sign up failed'));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isSendingOtp = ref.watch(
      otpProvider.select((s) => s.status == OtpStatus.sending),
    );
    final isLoading = authState.status == AuthStatus.loading || isSendingOtp;
    final formState = ref.watch(signupFormProvider);

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
                    onPressed: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go('/onboarding');
                      }
                    },
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

            // ─── Scrollable Form Canvas ──────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      context.tr('Create Borrower Account'),
                      style: AppTypography.headlineLgMobile.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      context.tr(
                        'Empowering MSMEs and business owners with transparent institutional credit.',
                      ),
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Field 1: Full Legal Name
                    AppTextField(
                      label: context.tr('Full Legal Name (As per PAN)'),
                      controller: _nameController,
                      hint: 'Rajesh Kumar Gowda',
                      suffix: const Icon(
                        Icons.badge_outlined,
                        size: 20,
                        color: AppColors.outline,
                      ),
                      helperText: context.tr('Must match your PAN card record'),
                    ),
                    const SizedBox(height: 16),

                    // Field 2: Email
                    AppTextField(
                      label: context.tr('Email Address'),
                      controller: _emailController,
                      hint: 'name@company.com',
                      keyboardType: TextInputType.emailAddress,
                      suffix: const Icon(
                        Icons.mail_outline,
                        size: 18,
                        color: AppColors.onTertiaryContainer,
                      ),
                      helperText: context.tr(
                        "We'll email a 6-digit verification code",
                      ),
                    ),
                    const SizedBox(height: 12),
                    Divider(
                      color: AppColors.outlineVariant.withValues(alpha: 0.4),
                      height: 1,
                    ),
                    const SizedBox(height: 12),

                    // Consent 1: Terms
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: Checkbox(
                            value: formState.consentTerms,
                            activeColor: AppColors.primaryContainer,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2),
                            ),
                            onChanged: (val) {
                              ref
                                  .read(signupFormProvider.notifier)
                                  .setConsentTerms(val ?? false);
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            context.tr(
                              "I agree to Arohya Capital's Terms of Service, Privacy Policy, and RBI Digital Lending Fair Practice Code.",
                            ),
                            style: AppTypography.bodySm.copyWith(
                              color: AppColors.onSurface,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Consent 2: Bureau
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: Checkbox(
                            value: formState.consentBureau,
                            activeColor: AppColors.primaryContainer,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2),
                            ),
                            onChanged: (val) {
                              ref
                                  .read(signupFormProvider.notifier)
                                  .setConsentBureau(val ?? false);
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: AppTypography.bodySm.copyWith(
                                color: AppColors.onSurfaceVariant,
                                height: 1.3,
                              ),
                              children: [
                                TextSpan(
                                  text: context.tr(
                                    'Consent to fetch credit report via Account Aggregator / Bureau ',
                                  ),
                                ),
                                TextSpan(
                                  text: context.tr(
                                    '(Soft Inquiry only, no bureau score impact).',
                                  ),
                                  style: AppTypography.labelSm.copyWith(
                                    color: AppColors.onTertiaryContainer,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Primary CTA
                    AppButton(
                      text: context.tr('Continue'),
                      icon: Icons.arrow_forward,
                      isLoading: isLoading,
                      onPressed: _handleContinue,
                    ),
                    const SizedBox(height: 12),

                    // Divider with OR
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: AppColors.outlineVariant.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            context.tr('OR'),
                            style: AppTypography.caption.copyWith(
                              color: AppColors.outline,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: AppColors.outlineVariant.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Google Sign Up Button
                    AppButton(
                      text: context.tr('Sign up with Google'),
                      variant: AppButtonVariant.google,
                      isLoading: isLoading,
                      onPressed: _handleGoogleSignup,
                    ),
                    const SizedBox(height: 14),

                    // Already registered? Sign In
                    Center(
                      child: InkWell(
                        onTap: () => context.push('/login'),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                context.tr('Already registered? '),
                                style: AppTypography.labelMd.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                              Text(
                                context.tr('Sign In'),
                                style: AppTypography.labelMd.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
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

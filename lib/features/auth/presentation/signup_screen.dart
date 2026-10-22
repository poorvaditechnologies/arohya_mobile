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

/// Sign Up Screen matching Image 3 / Stitch Signup design.
///
/// Features:
/// - Header with "C-KYC READY" tag
/// - Legal Name, email Number, PAN fields
/// - 2x2 Entity / Business Type selector
/// - Expandable Advisor Referral Code field
/// - DPDP & RBI Fair Practice Consent checkboxes
/// - Primary CTA ("Register & Verify OTP")
/// - **Google Sign Up button** (as requested by user)
/// - Bank-Grade 256-Bit DPDP Act footer
class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _nameController = TextEditingController(text: 'Rajesh Kumar Gowda');
  final _emailController = TextEditingController(text: '9845012849');
  final _panController = TextEditingController(text: 'ABCDE1234F');
  final _advisorController = TextEditingController();

  final String _selectedEntityType = 'Sole Proprietorship';
  // bool _showAdvisorField = false;
  bool _consentTerms = false;
  bool _consentBureau = false;

  // final List<String> _entityTypes = [
  //   'Sole Proprietorship',
  //   'Partnership / LLP',
  //   'Private Limited',
  //   'Salaried / Self-Employed',
  // ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _panController.dispose();
    _advisorController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final pan = _panController.text.trim();

    if (name.isEmpty) {
      AppSnackbar.showError(context, 'Please enter your full legal name');
      return;
    }
    if (email.length < 10) {
      AppSnackbar.showError(
        context,
        'Please enter a valid 10-digit email number',
      );
      return;
    }
    if (pan.length != 10) {
      AppSnackbar.showError(
        context,
        'Please enter a valid 10-digit PAN number',
      );
      return;
    }
    if (!_consentTerms || !_consentBureau) {
      AppSnackbar.showWarning(
        context,
        'Please accept the statutory consent items to proceed',
      );
      return;
    }

    try {
      await ref.read(otpProvider.notifier).sendOtp(
            PendingSignup(
              fullName: name,
              email: email,
              pan: pan,
              entityType: _selectedEntityType,
              advisorCode: _advisorController.text.trim().isEmpty
                  ? null
                  : _advisorController.text.trim(),
            ),
          );
      if (mounted) {
        context.go('/verify-otp');
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.showError(context, 'Registration failed: $e');
      }
    }
  }

  Future<void> _handleGoogleSignup() async {
    try {
      await ref.read(authProvider.notifier).loginWithGoogle();
      if (mounted) {
        AppSnackbar.showSuccess(
          context,
          'Google account linked. Welcome Rajesh!',
        );
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.showError(context, 'Google sign up failed');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState.status == AuthStatus.loading;

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
                      'Create Borrower Account',
                      style: AppTypography.headlineLgMobile.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Empowering MSMEs and business owners with transparent institutional credit.',
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Field 1: Full Legal Name
                    AppTextField(
                      label: 'Full Legal Name (As per PAN)',
                      controller: _nameController,
                      hint: 'Rajesh Kumar Gowda',
                      suffix: const Icon(
                        Icons.badge_outlined,
                        size: 20,
                        color: AppColors.outline,
                      ),
                      helperText: 'Must match your PAN card record',
                    ),
                    const SizedBox(height: 16),

                    // Field 2: email Number
                    AppTextField(
                      label: 'email Number',
                      controller: _emailController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      prefix: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🇮🇳', style: TextStyle(fontSize: 16)),
                          const SizedBox(width: 4),
                          Text(
                            '+91',
                            style: AppTypography.bodyMd.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurface,
                            ),
                          ),
                          Container(
                            height: 20,
                            width: 1,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            color: AppColors.outlineVariant,
                          ),
                        ],
                      ),
                      suffix: const Icon(
                        Icons.sms,
                        size: 18,
                        color: AppColors.onTertiaryContainer,
                      ),
                      helperText: '10-digit WhatsApp/SMS enabled number',
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
                            value: _consentTerms,
                            activeColor: AppColors.primaryContainer,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2),
                            ),
                            onChanged: (val) {
                              setState(() {
                                _consentTerms = val ?? false;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "I agree to Arohya Capital's Terms of Service, Privacy Policy, and RBI Digital Lending Fair Practice Code.",
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
                            value: _consentBureau,
                            activeColor: AppColors.primaryContainer,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2),
                            ),
                            onChanged: (val) {
                              setState(() {
                                _consentBureau = val ?? true;
                              });
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
                                const TextSpan(
                                  text:
                                      'Consent to fetch credit report via Account Aggregator / Bureau ',
                                ),
                                TextSpan(
                                  text:
                                      '(Soft Inquiry only, no bureau score impact).',
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
                      text: 'Register & Verify OTP',
                      icon: Icons.arrow_forward,
                      isLoading: isLoading,
                      onPressed: _handleSignup,
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
                            'OR',
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
                      text: 'Sign up with Google',
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
                                'Already registered? ',
                                style: AppTypography.labelMd.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                              Text(
                                'Sign In',
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

            // ─── Regulatory DPDP Act Footer ──────────────────────────
            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            //   decoration: BoxDecoration(
            //     color: AppColors.surfaceContainerLow,
            //     border: Border(
            //       top: BorderSide(
            //         color: AppColors.outlineVariant.withValues(alpha: 0.3),
            //       ),
            //     ),
            //   ),
            //   child: Column(
            //     children: [
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           const Icon(
            //             Icons.lock,
            //             size: 13,
            //             color: AppColors.secondary,
            //           ),
            //           const SizedBox(width: 6),
            //           Text(
            //             '256-BIT BANK-GRADE ENCRYPTION',
            //             style: AppTypography.caption.copyWith(
            //               color: AppColors.onSurface,
            //               fontWeight: FontWeight.w700,
            //               letterSpacing: 0.5,
            //             ),
            //           ),
            //         ],
            //       ),
            //       const SizedBox(height: 2),
            //       Text(
            //         'Your data is strictly encrypted and protected under Digital Personal Data Protection (DPDP) Act & RBI regulatory frameworks.',
            //         textAlign: TextAlign.center,
            //         style: AppTypography.caption.copyWith(
            //           color: AppColors.onSurfaceVariant,
            //           fontSize: 10,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

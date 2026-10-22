import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/swipe_to_action_button.dart';
import '../models/auth_model.dart';
import '../provider/auth_provider.dart';
import '../provider/otp_provider.dart';
import '../../../core/localization/app_localizations.dart';

/// Login Screen matching Image 3 / Stitch Login design.
///
/// Features:
/// - 256-Bit SSL badge in header
/// - Email OTP & Password/MPIN segmented tab switcher
/// - Swipe-to-confirm CTA ("Get Secure OTP" opens the OTP screen,
///   "Sign In" logs in directly)
/// - Biometric Quick Sign-in Card
/// - Google Sign In button
/// - Fiduciary trust footer
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController(
    text: 'rajesh.gowda@example.com',
  );
  final _mpinController = TextEditingController();

  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void dispose() {
    _emailController.dispose();
    _mpinController.dispose();
    super.dispose();
  }

  /// Returns the trimmed email, or shows an error and returns null.
  String? _validatedEmail() {
    final email = _emailController.text.trim();
    if (!_emailPattern.hasMatch(email)) {
      AppSnackbar.showError(context, context.tr('Please enter a valid email address'));
      return null;
    }
    return email;
  }

  /// "Get Secure OTP": emails a code, then continues on the OTP screen.
  Future<void> _handleSendOtp() async {
    final email = _validatedEmail();
    if (email == null) return;

    try {
      await ref.read(otpProvider.notifier).sendLoginOtp(email);
      if (mounted) {
        AppSnackbar.showInfo(
          context,
          context.tr('Verification code sent to {email}', args: {'email': email}),
        );
        context.push('/verify-otp');
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.showError(
          context,
          context.tr('Could not send verification code: {error}', args: {'error': e}),
        );
      }
    }
  }

  /// "Sign In" (password / MPIN) and biometrics: logs in without an OTP.
  Future<void> _handleLogin() async {
    final email = _validatedEmail();
    if (email == null) return;

    try {
      await ref.read(authProvider.notifier).loginWithEmail(email: email);
      if (mounted) {
        AppSnackbar.showSuccess(
          context,
          context.tr('Authentication successful. Welcome Rajesh!'),
        );
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.showError(
          context,
          context.tr('Login failed: {error}', args: {'error': e}),
        );
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      await ref.read(authProvider.notifier).loginWithGoogle();
      if (mounted) {
        AppSnackbar.showSuccess(
          context,
          context.tr('Signed in with Google. Welcome Rajesh!'),
        );
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.showError(context, context.tr('Google sign in failed'));
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
    final selectedTab = ref.watch(loginTabProvider);
    final rememberDevice = ref.watch(rememberDeviceProvider);
    final obscurePassword = ref.watch(obscurePasswordProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Ambient Top Trust Line
            Container(
              height: 3,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryContainer,
                    AppColors.secondaryContainer,
                    AppColors.primaryContainer,
                  ],
                ),
              ),
            ),

            // ─── Header ──────────────────────────────────────────────
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
                    color: AppColors.onSurfaceVariant,
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: AppColors.outlineVariant.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.lock,
                          size: 12,
                          color: AppColors.onTertiaryContainer,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          context.tr('256-Bit SSL'),
                          style: AppTypography.caption.copyWith(
                            color: AppColors.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ─── Scrollable Form ─────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Typography Anchor
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: AppColors.outlineVariant.withValues(
                            alpha: 0.4,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.onTertiaryContainer,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            context.tr('SECURE CLIENT GATEWAY'),
                            style: AppTypography.caption.copyWith(
                              color: AppColors.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      context.tr('Welcome Back'),
                      style: AppTypography.headlineLgMobile.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      context.tr('Sign in to access your credit facilities and active applications.'),
                      style: AppTypography.bodyMd.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Segmented Method Switcher
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.outlineVariant.withValues(
                            alpha: 0.4,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildTabButton(
                              index: 0,
                              title: 'Email OTP',
                              icon: Icons.mail_outline,
                              isSelected: selectedTab == 0,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: _buildTabButton(
                              index: 1,
                              title: 'Password / MPIN',
                              icon: Icons.dialpad,
                              isSelected: selectedTab == 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Email Input
                    AppTextField(
                      label: context.tr('Registered Email Address'),
                      controller: _emailController,
                      hint: 'name@company.com',
                      keyboardType: TextInputType.emailAddress,
                      suffix: const Icon(
                        Icons.mail_outline,
                        color: AppColors.onTertiaryContainer,
                        size: 20,
                      ),
                      helperText: selectedTab == 0
                          ? context.tr(
                              'One-Time Password will be emailed to this address.',
                            )
                          : context.tr(
                              'Use the email address linked to your account.',
                            ),
                    ),

                    if (selectedTab == 1) ...[
                      const SizedBox(height: 14),
                      AppTextField(
                        label: context.tr('Password or 6-digit MPIN'),
                        controller: _mpinController,
                        obscureText: obscurePassword,
                        keyboardType: TextInputType.visiblePassword,
                        suffix: IconButton(
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            size: 20,
                            color: AppColors.outline,
                          ),
                          onPressed: () {
                            ref.read(obscurePasswordProvider.notifier).state =
                                !obscurePassword;
                          },
                        ),
                      ),
                    ],

                    const SizedBox(height: 16),

                    // Biometric Quick Sign-in Card
                    InkWell(
                      onTap: _handleLogin,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow.withValues(
                            alpha: 0.7,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.outlineVariant.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.primaryContainer,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(
                                Icons.fingerprint,
                                size: 24,
                                color: AppColors.secondaryFixed,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        context.tr('Sign in with Biometrics'),
                                        style: AppTypography.labelMd.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.onSurface,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 1,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              AppColors.surfaceContainerHighest,
                                          borderRadius: BorderRadius.circular(
                                            3,
                                          ),
                                        ),
                                        child: Text(
                                          context.tr('Active'),
                                          style: AppTypography.caption.copyWith(
                                            color:
                                                AppColors.onTertiaryContainer,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    context.tr('Enabled for Rajesh Kumar Gowda'),
                                    style: AppTypography.caption.copyWith(
                                      color: AppColors.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: AppColors.outline,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Remember Device Checkbox
                    Row(
                      children: [
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: Checkbox(
                            value: rememberDevice,
                            activeColor: AppColors.primaryContainer,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3),
                            ),
                            onChanged: (val) {
                              ref.read(rememberDeviceProvider.notifier).state =
                                  val ?? true;
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          context.tr('Remember this device for 30 days'),
                          style: AppTypography.bodySm.copyWith(
                            color: AppColors.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.info_outline,
                          size: 16,
                          color: AppColors.outline,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Primary CTA Button
                    SwipeToActionButton(
                      text: selectedTab == 0
                          ? context.tr('Get Secure OTP')
                          : context.tr('Sign In'),
                      isLoading: isLoading,
                      onCompleted: selectedTab == 0
                          ? _handleSendOtp
                          : _handleLogin,
                    ),
                    const SizedBox(height: 14),

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
                    const SizedBox(height: 14),

                    // Google Sign In Button
                    AppButton(
                      text: context.tr('Continue with Google'),
                      variant: AppButtonVariant.google,
                      isLoading: isLoading,
                      onPressed: _handleGoogleSignIn,
                    ),
                    const SizedBox(height: 14),

                    // Don't have an account link
                    Center(
                      child: InkWell(
                        onTap: () => context.push('/signup'),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                context.tr("Don't have an account? "),
                                style: AppTypography.bodySm.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                              Text(
                                context.tr('Create Account'),
                                style: AppTypography.bodySm.copyWith(
                                  color: AppColors.secondary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Support Link
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.support_agent,
                            size: 16,
                            color: AppColors.outline,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            context.tr('Having trouble signing in? '),
                            style: AppTypography.caption.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            context.tr('Contact Fiduciary Support'),
                            style: AppTypography.caption.copyWith(
                              color: AppColors.secondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ─── Institutional Safeguard Footer ──────────────────────
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
            //             Icons.verified_user,
            //             size: 13,
            //             color: AppColors.onSurfaceVariant,
            //           ),
            //           const SizedBox(width: 6),
            //           Text(
            //             'Protected by Sovereign Cryptographic Vault • ISO 27001 Certified',
            //             style: AppTypography.caption.copyWith(
            //               color: AppColors.onSurfaceVariant,
            //               fontWeight: FontWeight.w500,
            //             ),
            //           ),
            //         ],
            //       ),
            //       const SizedBox(height: 2),
            //       Text(
            //         'Arohya Capital Private Limited • Reserve Bank of India Licensed Fiduciary',
            //         style: AppTypography.caption.copyWith(
            //           color: AppColors.outline,
            //           fontSize: 9,
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

  Widget _buildTabButton({
    required int index,
    required String title,
    required IconData icon,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () {
        ref.read(loginTabProvider.notifier).state = index;
      },
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.surfaceContainerLowest
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
          border: isSelected
              ? Border.all(
                  color: AppColors.outlineVariant.withValues(alpha: 0.3),
                )
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected
                  ? AppColors.primaryContainer
                  : AppColors.outline,
            ),
            const SizedBox(width: 6),
            Text(context.tr(title),
              style: AppTypography.labelMd.copyWith(
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? AppColors.onSurface
                    : AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

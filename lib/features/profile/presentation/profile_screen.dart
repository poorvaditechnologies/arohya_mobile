import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../auth/provider/auth_provider.dart';

/// Profile screen with borrower identity, entity verification, and logout capability.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final userName = authState.userName ?? 'Rajesh Kumar Gowda';
    final mobileNumber = authState.mobileNumber ?? '98450 12849';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.secondary.withValues(alpha: 0.35),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Center(
                    child: Text(
                      userName.isNotEmpty ? userName[0] : 'R',
                      style: AppTypography.headlineLg.copyWith(
                        color: AppColors.primaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              userName,
                              style: AppTypography.headlineSm.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.verified,
                            size: 16,
                            color: AppColors.secondaryContainer,
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '+91 $mobileNumber',
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.outlineVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.tertiaryFixed.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          'C-KYC Verified Entity',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.tertiaryFixed,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Business Entity Information
          // Text(
          //   'Entity & Verification Details',
          //   style: AppTypography.labelMd.copyWith(
          //     color: AppColors.onSurface,
          //     fontWeight: FontWeight.w700,
          //   ),
          // ),
          // const SizedBox(height: 10),
          // _buildInfoRow('Business Type', 'Sole Proprietorship'),
          // _buildInfoRow('PAN Number', 'ABCDE1234F'),
          // _buildInfoRow('GSTIN Status', 'Verified (AAACB1234F1Z5)'),
          // _buildInfoRow('Account Aggregator', 'Linked (9845012849@finvu)'),
          // const SizedBox(height: 20),

          // Security & Preferences
          Text(
            'Security & Consent',
            style: AppTypography.labelMd.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          _buildPreferenceTile(
            icon: Icons.fingerprint,
            title: 'Biometric Unlock',
            subtitle: 'Fingerprint and Face ID authentication',
            trailing: Switch(
              value: true,
              activeThumbColor: AppColors.secondary,
              onChanged: (val) {},
            ),
          ),
          const SizedBox(height: 8),
          _buildPreferenceTile(
            icon: Icons.lock_outline,
            title: 'Change MPIN',
            subtitle: 'Update your 6-digit access PIN',
            trailing: const Icon(Icons.chevron_right, color: AppColors.outline),
          ),
          const SizedBox(height: 8),
          _buildPreferenceTile(
            icon: Icons.description_outlined,
            title: 'Statutory DPDP Consent Record',
            subtitle: 'View active data authorizations',
            trailing: const Icon(Icons.chevron_right, color: AppColors.outline),
          ),
          const SizedBox(height: 24),

          // Logout Action
          AppButton(
            text: 'Sign Out of Session',
            variant: AppButtonVariant.secondary,
            icon: Icons.logout,
            onPressed: () {
              ref.read(authProvider.notifier).logout();
              AppSnackbar.showInfo(
                context,
                'You have been securely signed out.',
              );
              context.go('/login');
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildPreferenceTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, size: 18, color: AppColors.primaryContainer),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.labelMd.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}

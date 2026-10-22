import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_skeleton.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../auth/provider/auth_provider.dart';
import '../models/profile_model.dart';
import '../provider/profile_provider.dart';
import '../widget/profile_widgets.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileProvider);
    if (state.isLoading && state.profile == null) {
      return const _ProfileSkeleton();
    }
    if (state.profile == null) {
      return _ProfileError(
        message: state.errorMessage ?? 'Unable to load profile',
        onRetry: () => ref.read(profileProvider.notifier).loadProfile(),
      );
    }

    return _ProfileContent(profile: state.profile!, state: state);
  }
}

class _ProfileContent extends ConsumerWidget {
  final ProfileModel profile;
  final ProfileState state;

  const _ProfileContent({required this.profile, required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactLine = profile.email.isNotEmpty
        ? profile.email
        : '+91 ${profile.mobileNumber}';

    return RefreshIndicator(
      onRefresh: () => ref.read(profileProvider.notifier).loadProfile(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: AppColors.surfaceContainerLowest,
                    backgroundImage: profile.avatarUrl?.isNotEmpty == true
                        ? NetworkImage(profile.avatarUrl!)
                        : null,
                    child: profile.avatarUrl?.isNotEmpty == true
                        ? null
                        : Text(
                            profile.fullName.isEmpty
                                ? 'A'
                                : profile.fullName[0].toUpperCase(),
                            style: AppTypography.headlineLg.copyWith(
                              color: AppColors.primaryContainer,
                              fontWeight: FontWeight.bold,
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
                                profile.fullName,
                                style: AppTypography.headlineSm.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (profile.kycStatus.toLowerCase() == 'verified')
                              const Padding(
                                padding: EdgeInsets.only(left: 6),
                                child: Icon(
                                  Icons.verified,
                                  size: 16,
                                  color: AppColors.secondaryContainer,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          contactLine,
                          style: AppTypography.bodySm.copyWith(
                            color: AppColors.outlineVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          context.tr('C-KYC Verified Entity'),
                          style: AppTypography.caption.copyWith(
                            color: AppColors.tertiaryFixed,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              context.tr('Entity & Verification Details'),
              style: AppTypography.labelMd.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            ProfileInfoRow(
              label: context.tr('Business Type'),
              value: profile.businessType,
            ),
            ProfileInfoRow(
              label: context.tr('PAN Number'),
              value: profile.panMasked,
            ),
            ProfileInfoRow(
              label: context.tr('GSTIN Status'),
              value: '${profile.gstinStatus} (${profile.gstinMasked})',
            ),
            ProfileInfoRow(
              label: context.tr('Account Aggregator'),
              value:
                  '${profile.accountAggregatorStatus} (${profile.accountAggregatorHandle})',
            ),
            const SizedBox(height: 20),
            Text(
              context.tr('Security & Consent'),
              style: AppTypography.labelMd.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            ProfilePreferenceTile(
              icon: Icons.fingerprint,
              title: 'Biometric Unlock',
              subtitle: 'Fingerprint and Face ID authentication',
              trailing: Switch(
                value: profile.biometricEnabled,
                activeThumbColor: AppColors.secondary,
                onChanged: state.isUpdatingPreference
                    ? null
                    : (value) async {
                        try {
                          await ref
                              .read(profileProvider.notifier)
                              .toggleBiometrics(value);
                        } catch (error) {
                          if (context.mounted) {
                            AppSnackbar.showError(context, error.toString());
                          }
                        }
                      },
              ),
            ),
            const SizedBox(height: 8),
            const ProfilePreferenceTile(
              icon: Icons.lock_outline,
              title: 'Change MPIN',
              subtitle: 'Update your 6-digit access PIN',
              trailing: Icon(Icons.chevron_right, color: AppColors.outline),
            ),
            const SizedBox(height: 24),
            AppButton(
              text: context.tr('Sign Out of Session'),
              variant: AppButtonVariant.secondary,
              icon: Icons.logout,
              onPressed: () async {
                await ref.read(authProvider.notifier).logout();
                if (!context.mounted) return;
                AppSnackbar.showInfo(
                  context,
                  context.tr('You have been securely signed out.'),
                );
                context.go('/login');
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _ProfileSkeleton extends StatelessWidget {
  const _ProfileSkeleton();

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 112,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              children: [
                SkeletonBox(width: 52, height: 52, borderRadius: 26),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonBox(width: 180, height: 18),
                      SizedBox(height: 10),
                      SkeletonBox(width: 220, height: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const SkeletonBox(width: 190, height: 16),
          const SizedBox(height: 12),
          ...List.generate(
            5,
            (_) => const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: SkeletonBox(height: 58, borderRadius: 8),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ProfileError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            TextButton(onPressed: onRetry, child: Text(context.tr('Retry'))),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_skeleton.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../models/support_model.dart';
import '../provider/support_provider.dart';
import '../widget/support_channel_tile.dart';

class SupportScreen extends ConsumerWidget {
  const SupportScreen({super.key});

  Future<void> _scheduleCallback(BuildContext context, WidgetRef ref) async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year, now.month, now.day + 1);
    final date = await showDatePicker(
      context: context,
      initialDate: firstDate,
      firstDate: firstDate,
      lastDate: DateTime(now.year + 1),
    );
    if (date == null || !context.mounted) return;

    final timeSlot = await showModalBottomSheet<String>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(title: Text('Choose a preferred time')),
            for (final slot in const [
              '09:00-11:00',
              '11:00-13:00',
              '14:00-16:00',
              '16:00-18:00',
            ])
              ListTile(
                title: Text(slot),
                onTap: () => Navigator.pop(sheetContext, slot),
              ),
          ],
        ),
      ),
    );
    if (timeSlot == null || !context.mounted) return;

    try {
      final message = await ref
          .read(supportProvider.notifier)
          .scheduleCallback(
            preferredDate: date,
            preferredTimeSlot: timeSlot,
            topic: 'Credit Consultation',
          );
      if (context.mounted) {
        AppSnackbar.showSuccess(context, message);
      }
    } catch (error) {
      if (context.mounted) {
        AppSnackbar.showError(context, error.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(supportProvider);
    if (state.isLoading && state.config == null) {
      return const _SupportSkeleton();
    }
    if (state.config == null) {
      return _SupportError(
        message: state.errorMessage ?? 'Unable to load support information',
        onRetry: () => ref.read(supportProvider.notifier).loadSupport(),
      );
    }

    final config = state.config!;
    return RefreshIndicator(
      onRefresh: () => ref.read(supportProvider.notifier).loadSupport(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr('Fiduciary Support Desk'),
              style: AppTypography.headlineLgMobile.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              context.tr(
                'Direct access to institutional relationship managers and credit advisors.',
              ),
              style: AppTypography.bodySm.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            _RelationshipManagerCard(manager: config.relationshipManager),
            const SizedBox(height: 16),
            ...config.channels.map(
              (channel) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: SupportChannelTile(channel: channel),
              ),
            ),
            const SizedBox(height: 16),
            AppButton(
              text: context.tr('Schedule Call with Credit Underwriter'),
              icon: Icons.calendar_today,
              isLoading: state.isScheduling,
              onPressed: () => _scheduleCallback(context, ref),
            ),
          ],
        ),
      ),
    );
  }
}

class _RelationshipManagerCard extends StatelessWidget {
  final RelationshipManagerModel manager;

  const _RelationshipManagerCard({required this.manager});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primaryContainer,
            backgroundImage: manager.profileImageUrl?.isNotEmpty == true
                ? NetworkImage(manager.profileImageUrl!)
                : null,
            child: manager.profileImageUrl?.isNotEmpty == true
                ? null
                : Text(
                    manager.initials,
                    style: const TextStyle(
                      color: AppColors.secondaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  manager.name,
                  style: AppTypography.labelMd.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                Text(
                  context.tr(manager.title),
                  style: AppTypography.caption.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: manager.available
                            ? AppColors.onTertiaryContainer
                            : AppColors.outline,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        context.tr(manager.availabilityLabel),
                        style: AppTypography.caption.copyWith(
                          color: AppColors.onTertiaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SupportSkeleton extends StatelessWidget {
  const _SupportSkeleton();

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SkeletonBox(width: 230, height: 24),
          const SizedBox(height: 10),
          const SkeletonBox(height: 14),
          const SizedBox(height: 4),
          const SkeletonBox(width: 260, height: 14),
          const SizedBox(height: 20),
          const SkeletonBox(height: 96, borderRadius: 8),
          const SizedBox(height: 16),
          ...List.generate(
            3,
            (_) => const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: SkeletonBox(height: 68, borderRadius: 8),
            ),
          ),
          const SizedBox(height: 16),
          const SkeletonBox(height: 48, borderRadius: 8),
        ],
      ),
    );
  }
}

class _SupportError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _SupportError({required this.message, required this.onRetry});

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

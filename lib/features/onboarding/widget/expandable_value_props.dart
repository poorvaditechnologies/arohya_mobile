import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../models/onboarding_model.dart';
import '../provider/onboarding_provider.dart';
import 'value_prop_item.dart';
import '../../../core/localization/app_localizations.dart';

/// Expandable "Read More" widget displaying the institutional trust & regulatory items.
class ExpandableValueProps extends ConsumerWidget {
  final List<ValuePropModel> valueProps;

  const ExpandableValueProps({
    super.key,
    required this.valueProps,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded = ref.watch(
      onboardingProvider.select((s) => s.isValuePropsExpanded),
    );

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header / Read More Trigger Row
          InkWell(
            onTap: () {
              ref.read(onboardingProvider.notifier).toggleValuePropsExpanded();
            },
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.verified_user_outlined,
                      size: 18,
                      color: AppColors.primaryContainer,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.tr('Institutional Framework & Safeguards'),
                          style: AppTypography.labelMd.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isExpanded
                              ? context.tr('Tap to collapse regulatory details')
                              : context.tr(
                                  'Tap to read more on RBI, AA & KFS compliance',
                                ),
                          style: AppTypography.caption.copyWith(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isExpanded
                          ? AppColors.surfaceContainerHigh
                          : AppColors.secondaryContainer.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isExpanded
                            ? AppColors.outlineVariant.withValues(alpha: 0.5)
                            : AppColors.secondary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isExpanded
                              ? context.tr('Show less')
                              : context.tr('Read more'),
                          style: AppTypography.caption.copyWith(
                            color: isExpanded
                                ? AppColors.onSurfaceVariant
                                : AppColors.secondary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          size: 16,
                          color: isExpanded
                              ? AppColors.onSurfaceVariant
                              : AppColors.secondary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expandable Animated Body
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubic,
            child: isExpanded
                ? Column(
                    children: [
                      Divider(
                        height: 1,
                        color: AppColors.outlineVariant.withValues(alpha: 0.3),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: valueProps
                              .map(
                                (prop) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: ValuePropItemWidget(model: prop),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

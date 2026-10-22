import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/localization/locale_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../provider/home_provider.dart';
import 'dashboard_tab.dart';
import '../../loans/screens/loans_screen.dart';
import '../../support/screens/support_screen.dart';
import '../../profile/screens/profile_screen.dart';

/// Main Home Screen Shell with top bar and 4-tab bottom navigation.
///
/// Customization applied per user requirement:
/// - ✅ REMOVED "Applications" tab
/// - Strictly 4 tabs: [0] Home, [1] Loans, [2] Support, [3] Profile
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const List<Widget> _tabs = [
    DashboardTab(),
    LoansScreen(),
    SupportScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(selectedTabProvider);
    final isKannada =
        ref.watch(appLocaleProvider).languageCode ==
        AppLocalizations.kannada.languageCode;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border(
              bottom: BorderSide(
                color: AppColors.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Brand Mark
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: AppColors.secondaryContainer.withValues(alpha: 0.4),
                          ),
                        ),
                        child: const Icon(
                          Icons.account_balance,
                          size: 18,
                          color: AppColors.secondaryContainer,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'AROHYA CAPITAL',
                        style: AppTypography.headlineSm.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ],
                  ),

                  // Actions: Language Toggle + Notifications
                  Row(
                    children: [
                      // Language Pill
                      InkWell(
                        onTap: () => ref.read(appLocaleProvider.notifier).toggle(),
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: AppColors.outlineVariant.withValues(alpha: 0.4),
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'EN',
                                style: AppTypography.caption.copyWith(
                                  fontWeight: !isKannada ? FontWeight.w800 : FontWeight.w500,
                                  color: !isKannada ? AppColors.primary : AppColors.onSurfaceVariant,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  '|',
                                  style: AppTypography.caption.copyWith(
                                    color: AppColors.outlineVariant,
                                  ),
                                ),
                              ),
                              Text(
                                'ಕನ್ನಡ',
                                style: AppTypography.caption.copyWith(
                                  fontWeight: isKannada ? FontWeight.w800 : FontWeight.w500,
                                  color: isKannada ? AppColors.primary : AppColors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),

                      // Notification Bell
                      IconButton(
                        icon: Stack(
                          children: [
                            const Icon(
                              Icons.notifications_outlined,
                              size: 22,
                              color: AppColors.onSurface,
                            ),
                            Positioned(
                              top: 2,
                              right: 2,
                              child: Container(
                                width: 7,
                                height: 7,
                                decoration: const BoxDecoration(
                                  color: AppColors.secondary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {
                          AppSnackbar.showInfo(context, context.tr('No new notifications'));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: IndexedStack(
        index: currentTab,
        children: _tabs,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          border: Border(
            top: BorderSide(
              color: AppColors.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  ref: ref,
                  index: 0,
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home,
                  label: context.tr('Home'),
                  isSelected: currentTab == 0,
                ),
                _buildNavItem(
                  ref: ref,
                  index: 1,
                  icon: Icons.account_balance_outlined,
                  activeIcon: Icons.account_balance,
                  label: context.tr('Loans'),
                  isSelected: currentTab == 1,
                ),
                _buildNavItem(
                  ref: ref,
                  index: 2,
                  icon: Icons.support_agent_outlined,
                  activeIcon: Icons.support_agent,
                  label: context.tr('Support'),
                  isSelected: currentTab == 2,
                ),
                _buildNavItem(
                  ref: ref,
                  index: 3,
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  label: context.tr('Profile'),
                  isSelected: currentTab == 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required WidgetRef ref,
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () {
        ref.read(selectedTabProvider.notifier).state = index;
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              size: 22,
              color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: AppTypography.labelSm.copyWith(
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

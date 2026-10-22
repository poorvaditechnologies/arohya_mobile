import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/api/api_provider.dart';
import '../../../core/localization/locale_provider.dart';
import '../models/financing_solution_model.dart';
import '../models/home_model.dart';

/// Tracks the currently selected bottom navigation tab index.
///
/// 0 = Home, 1 = Loans, 2 = Support, 3 = Profile
final selectedTabProvider = StateProvider<int>((ref) => 0);

/// Active borrower credit application provider.
final dashboardProvider = FutureProvider<DashboardModel>((ref) async {
  final locale = ref.watch(appLocaleProvider);
  final response = await ref
      .watch(apiServiceProvider)
      .get<DashboardModel>(
        ApiEndpoints.dashboard,
        languageCode: locale.languageCode,
        decodeData: (json) =>
            DashboardModel.fromJson((json as Map).cast<String, dynamic>()),
      );
  return response.data!;
});

final financingSolutionsProvider = FutureProvider<FinancingSolutionsCatalog>((
  ref,
) async {
  final locale = ref.watch(appLocaleProvider);
  final response = await ref
      .watch(apiServiceProvider)
      .get<FinancingSolutionsCatalog>(
        ApiEndpoints.financingSolutions,
        authenticated: false,
        languageCode: locale.languageCode,
        decodeData: (json) => FinancingSolutionsCatalog.fromJson(
          (json as Map).cast<String, dynamic>(),
        ),
      );
  return response.data!;
});

final activeApplicationProvider = Provider<ApplicationModel?>((ref) {
  return ref.watch(dashboardProvider).asData?.value.activeApplication;
});

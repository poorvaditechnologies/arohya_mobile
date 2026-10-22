import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_endpoints.dart';
import '../../../core/api/api_provider.dart';
import '../../../core/api/api_service.dart';
import '../models/loan_model.dart';

class LoansState {
  final List<LoanFacilityModel> facilities;
  final bool isLoading;
  final String? errorMessage;

  const LoansState({
    this.facilities = const [],
    this.isLoading = true,
    this.errorMessage,
  });

  LoansState copyWith({
    List<LoanFacilityModel>? facilities,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return LoansState(
      facilities: facilities ?? this.facilities,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class LoansNotifier extends StateNotifier<LoansState> {
  final ApiService _api;

  LoansNotifier(this._api) : super(const LoansState()) {
    loadFacilities();
  }

  Future<void> loadFacilities() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final response = await _api.get<List<LoanFacilityModel>>(
        ApiEndpoints.loanFacilities,
        queryParameters: const {'page': 1, 'limit': 20},
        decodeData: (json) {
          final data = (json as Map).cast<String, dynamic>();
          final items = data['items'] as List? ?? const [];
          return items
              .whereType<Map>()
              .map(
                (item) =>
                    LoanFacilityModel.fromJson(item.cast<String, dynamic>()),
              )
              .toList(growable: false);
        },
      );
      state = LoansState(facilities: response.data ?? const []);
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
    }
  }

  Future<void> refreshFacilities() => loadFacilities();
}

final loansProvider = StateNotifierProvider<LoansNotifier, LoansState>((ref) {
  return LoansNotifier(ref.watch(apiServiceProvider));
});

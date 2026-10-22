import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_endpoints.dart';
import '../../../core/api/api_provider.dart';
import '../../../core/api/api_service.dart';
import '../models/support_model.dart';

class SupportState {
  final SupportConfigModel? config;
  final bool isLoading;
  final bool isScheduling;
  final String? errorMessage;

  const SupportState({
    this.config,
    this.isLoading = true,
    this.isScheduling = false,
    this.errorMessage,
  });

  SupportState copyWith({
    SupportConfigModel? config,
    bool? isLoading,
    bool? isScheduling,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SupportState(
      config: config ?? this.config,
      isLoading: isLoading ?? this.isLoading,
      isScheduling: isScheduling ?? this.isScheduling,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class SupportNotifier extends StateNotifier<SupportState> {
  final ApiService _api;

  SupportNotifier(this._api) : super(const SupportState()) {
    loadSupport();
  }

  Future<void> loadSupport() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final response = await _api.get<SupportConfigModel>(
        ApiEndpoints.support,
        decodeData: (json) =>
            SupportConfigModel.fromJson((json as Map).cast<String, dynamic>()),
      );
      state = SupportState(config: response.data, isLoading: false);
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
    }
  }

  Future<String> scheduleCallback({
    required DateTime preferredDate,
    required String preferredTimeSlot,
    required String topic,
  }) async {
    state = state.copyWith(isScheduling: true, clearError: true);
    try {
      final date =
          '${preferredDate.year}-${preferredDate.month.toString().padLeft(2, '0')}-${preferredDate.day.toString().padLeft(2, '0')}';
      final response = await _api.post<Map<String, dynamic>>(
        ApiEndpoints.callbackRequests,
        body: {
          'preferredDate': date,
          'preferredTimeSlot': preferredTimeSlot,
          'topic': topic,
        },
        decodeData: (json) => (json as Map).cast<String, dynamic>(),
      );
      state = state.copyWith(isScheduling: false);
      return response.message;
    } catch (error) {
      state = state.copyWith(
        isScheduling: false,
        errorMessage: error.toString(),
      );
      rethrow;
    }
  }
}

final supportProvider = StateNotifierProvider<SupportNotifier, SupportState>((
  ref,
) {
  return SupportNotifier(ref.watch(apiServiceProvider));
});

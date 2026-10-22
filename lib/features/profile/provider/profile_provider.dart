import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_endpoints.dart';
import '../../../core/api/api_provider.dart';
import '../../../core/api/api_service.dart';
import '../models/profile_model.dart';

class ProfileState {
  final ProfileModel? profile;
  final bool isLoading;
  final bool isUpdatingPreference;
  final String? errorMessage;

  const ProfileState({
    this.profile,
    this.isLoading = true,
    this.isUpdatingPreference = false,
    this.errorMessage,
  });

  ProfileState copyWith({
    ProfileModel? profile,
    bool? isLoading,
    bool? isUpdatingPreference,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      isUpdatingPreference: isUpdatingPreference ?? this.isUpdatingPreference,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  final ApiService _api;

  ProfileNotifier(this._api) : super(const ProfileState()) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final response = await _api.get<ProfileModel>(
        ApiEndpoints.profile,
        decodeData: (json) =>
            ProfileModel.fromJson((json as Map).cast<String, dynamic>()),
      );
      state = ProfileState(profile: response.data, isLoading: false);
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
    }
  }

  Future<void> toggleBiometrics(bool value) async {
    final current = state.profile;
    if (current == null || state.isUpdatingPreference) return;
    state = state.copyWith(
      profile: current.copyWith(biometricEnabled: value),
      isUpdatingPreference: true,
      clearError: true,
    );
    try {
      await _api.patch<Map<String, dynamic>>(
        ApiEndpoints.profilePreferences,
        body: {'biometricEnabled': value},
        decodeData: (json) => (json as Map).cast<String, dynamic>(),
      );
      state = state.copyWith(isUpdatingPreference: false);
    } catch (error) {
      state = state.copyWith(
        profile: current,
        isUpdatingPreference: false,
        errorMessage: error.toString(),
      );
      rethrow;
    }
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((
  ref,
) {
  return ProfileNotifier(ref.watch(apiServiceProvider));
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/api/api_provider.dart';
import '../../../core/api/api_response.dart';
import '../../../core/api/api_service.dart';
import '../models/auth_model.dart';

// ─── Auth Notifier ─────────────────────────────────────────
class AuthNotifier extends StateNotifier<AuthState> {
  final ApiService _api;

  AuthNotifier(this._api) : super(const AuthState());

  /// Password/MPIN authentication is not part of the current API contract.
  Future<void> loginWithEmail({required String email}) async {
    throw const ApiException(
      message:
          'Password and biometric login are not available yet. Use Email OTP.',
    );
  }

  Future<void> loginWithOtp({
    required String email,
    required String otp,
    required String otpRequestId,
    required bool rememberDevice,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final response = await _api.post<JsonMap>(
        ApiEndpoints.login,
        authenticated: false,
        body: {
          'email': email,
          'otp': otp,
          'otpRequestId': otpRequestId,
          'rememberDevice': rememberDevice,
        },
        decodeData: _decodeMap,
        timeout: ApiService.authenticationTimeout,
      );
      await _completeAuthentication(response.data!);
    } catch (error) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: error.toString(),
      );
      rethrow;
    }
  }

  /// Google authentication is not part of the current API contract.
  Future<void> loginWithGoogle() async {
    throw const ApiException(
      message: 'Google sign-in is not available from the current API.',
    );
  }

  Future<void> signup({
    required String fullName,
    required String email,
    required String pan,
    required String entityType,
    required String otp,
    required String otpRequestId,
    String? advisorCode,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final response = await _api.post<JsonMap>(
        ApiEndpoints.signUp,
        authenticated: false,
        body: {
          'fullName': fullName,
          'email': email,
          'pan': pan,
          'entityType': entityType,
          'advisorCode': advisorCode,
          'otp': otp,
          'otpRequestId': otpRequestId,
          'consents': {
            'termsAccepted': true,
            'bureauConsent': true,
            'privacyPolicyVersion': '2026-10-01',
            'acceptedAt': DateTime.now().toUtc().toIso8601String(),
          },
        },
        decodeData: _decodeMap,
        timeout: ApiService.authenticationTimeout,
      );
      await _completeAuthentication(response.data!);
    } catch (error) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: error.toString(),
      );
      rethrow;
    }
  }

  Future<void> logout() async {
    final refreshToken = await _api.tokenStorage.readRefreshToken();
    try {
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await _api.post<void>(
          ApiEndpoints.logout,
          body: {'refreshToken': refreshToken},
          timeout: ApiService.authenticationTimeout,
        );
      }
    } catch (_) {
      // A local sign-out must still succeed when the server is unreachable.
    } finally {
      await _api.tokenStorage.clear();
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  Future<void> _completeAuthentication(JsonMap data) async {
    final accessToken = data['accessToken'] as String?;
    final refreshToken = data['refreshToken'] as String?;
    final userJson = data['user'];
    if (accessToken == null ||
        refreshToken == null ||
        userJson is! Map<String, dynamic>) {
      throw const ApiException(
        message: 'Authentication response is incomplete.',
      );
    }
    await _api.tokenStorage.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
    final user = UserModel.fromJson(userJson);
    state = AuthState(
      status: AuthStatus.authenticated,
      userName: user.name.split(' ').first,
      mobileNumber: user.mobileNumber,
      email: user.email,
      user: user,
    );
  }

  static JsonMap _decodeMap(Object? json) =>
      (json as Map).cast<String, dynamic>();

  void clearError() {
    state = state.copyWith(status: AuthStatus.initial, errorMessage: null);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(apiServiceProvider));
});

// ─── Login Screen State Providers (Riverpod State Updating) ───────
/// Selected Login Tab: 0 = Email OTP, 1 = Password / MPIN
final loginTabProvider = StateProvider<int>((ref) => 0);

/// Remember this device toggle
final rememberDeviceProvider = StateProvider<bool>((ref) => true);

/// Password visibility toggle
final obscurePasswordProvider = StateProvider<bool>((ref) => true);

// ─── Signup Screen State Providers (Riverpod State Updating) ──────
class SignupFormState {
  final String entityType;
  final bool showAdvisorField;
  final bool consentTerms;
  final bool consentBureau;

  const SignupFormState({
    this.entityType = 'Sole Proprietorship',
    this.showAdvisorField = false,
    this.consentTerms = false,
    this.consentBureau = false,
  });

  SignupFormState copyWith({
    String? entityType,
    bool? showAdvisorField,
    bool? consentTerms,
    bool? consentBureau,
  }) {
    return SignupFormState(
      entityType: entityType ?? this.entityType,
      showAdvisorField: showAdvisorField ?? this.showAdvisorField,
      consentTerms: consentTerms ?? this.consentTerms,
      consentBureau: consentBureau ?? this.consentBureau,
    );
  }
}

class SignupFormNotifier extends StateNotifier<SignupFormState> {
  SignupFormNotifier() : super(const SignupFormState());

  void setEntityType(String type) {
    state = state.copyWith(entityType: type);
  }

  void toggleAdvisorField() {
    state = state.copyWith(showAdvisorField: !state.showAdvisorField);
  }

  void setConsentTerms(bool value) {
    state = state.copyWith(consentTerms: value);
  }

  void setConsentBureau(bool value) {
    state = state.copyWith(consentBureau: value);
  }

  void reset() {
    state = const SignupFormState();
  }
}

final signupFormProvider =
    StateNotifierProvider<SignupFormNotifier, SignupFormState>((ref) {
      return SignupFormNotifier();
    });

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/api/api_provider.dart';
import '../../../core/api/api_response.dart';
import '../../../core/api/api_service.dart';
import '../models/auth_model.dart';

/// Drives the email OTP step shared by signup and login.
///
class OtpNotifier extends StateNotifier<OtpState> {
  final ApiService _api;

  OtpNotifier(this._api) : super(const OtpState());

  /// Number of digits in the code.
  static const int length = 6;

  /// Seconds before the user may request a new code.
  static const int resendCooldownSeconds = 30;

  Future<void> sendOtp(PendingSignup pending) {
    final normalizedEmail = pending.email.trim().toLowerCase();
    return _send(
      OtpState(
        status: OtpStatus.sending,
        purpose: OtpPurpose.signup,
        email: normalizedEmail,
        pending: PendingSignup(
          fullName: pending.fullName,
          email: normalizedEmail,
          pan: pending.pan,
          entityType: pending.entityType,
          advisorCode: pending.advisorCode,
        ),
      ),
    );
  }

  Future<void> sendLoginOtp(String email) {
    return _send(
      OtpState(
        status: OtpStatus.sending,
        purpose: OtpPurpose.login,
        email: email.trim().toLowerCase(),
      ),
    );
  }

  /// Requests a fresh code for the email already being verified.
  Future<void> resend() async {
    if (state.email.isEmpty) return;
    await _send(state.copyWith(status: OtpStatus.sending));
  }

  Future<void> _send(OtpState sending) async {
    state = sending;
    try {
      final response = await _api.post<JsonMap>(
        ApiEndpoints.generateOtp,
        authenticated: false,
        body: {
          'email': sending.email,
          'purpose': sending.purpose == OtpPurpose.login ? 'login' : 'signUp',
        },
        decodeData: (json) => (json as Map).cast<String, dynamic>(),
        timeout: ApiService.authenticationTimeout,
      );
      final data = response.data!;
      final otpRequestId = data['otpRequestId'] as String? ?? '';
      if (otpRequestId.isEmpty) {
        throw const ApiException(
          message: 'The server did not return an OTP request ID. Please retry.',
        );
      }
      state = sending.copyWith(
        status: OtpStatus.sent,
        otpRequestId: otpRequestId,
        expiresInSeconds: (data['expiresInSeconds'] as num?)?.toInt() ?? 300,
        resendAfterSeconds: (data['resendAfterSeconds'] as num?)?.toInt() ?? 30,
      );
    } catch (_) {
      state = sending.copyWith(status: OtpStatus.failed);
      rethrow;
    }
  }

  void markVerifying() => state = state.copyWith(status: OtpStatus.verifying);

  void markVerified() => state = state.copyWith(status: OtpStatus.verified);

  void markFailed() => state = state.copyWith(status: OtpStatus.failed);

  void reset() {
    state = const OtpState();
  }
}

final otpProvider = StateNotifierProvider<OtpNotifier, OtpState>((ref) {
  return OtpNotifier(ref.watch(apiServiceProvider));
});

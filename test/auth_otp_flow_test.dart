import 'dart:convert';

import 'package:arohya/core/api/api_service.dart';
import 'package:arohya/features/auth/models/auth_model.dart';
import 'package:arohya/features/auth/provider/auth_provider.dart';
import 'package:arohya/features/auth/provider/otp_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('login OTP keeps the server request ID for verification', () async {
    final storage = _MemoryTokenStorage();
    late Map<String, dynamic> generateBody;
    late Map<String, dynamic> loginBody;

    final client = MockClient((request) async {
      final body = jsonDecode(request.body) as Map<String, dynamic>;
      if (request.url.path == '/api/v1/generate-otp') {
        generateBody = body;
        return _jsonResponse({
          'success': true,
          'message': 'Verification code sent successfully',
          'data': {
            'otpRequestId': 'otp_req_login_01',
            'expiresInSeconds': 300,
            'resendAfterSeconds': 30,
          },
        });
      }
      if (request.url.path == '/api/v1/login') {
        loginBody = body;
        return _jsonResponse({
          'success': true,
          'message': 'Login successful',
          'data': {
            'accessToken': 'access-token',
            'refreshToken': 'refresh-token',
            'user': {
              'id': 'user_01',
              'fullName': 'Rajesh Gowda',
              'email': 'rajesh.gowda@example.com',
            },
          },
        });
      }
      return _jsonResponse({
        'success': false,
        'message': 'Not found',
      }, statusCode: 404);
    });

    final api = ApiService(client: client, tokenStorage: storage);
    final otpNotifier = OtpNotifier(api);
    await otpNotifier.sendLoginOtp(' Rajesh.Gowda@Example.com ');

    expect(generateBody, {
      'email': 'rajesh.gowda@example.com',
      'purpose': 'login',
    });
    expect(otpNotifier.state.otpRequestId, 'otp_req_login_01');

    final authNotifier = AuthNotifier(api);
    await authNotifier.loginWithOtp(
      email: otpNotifier.state.email,
      otp: '123456',
      otpRequestId: otpNotifier.state.otpRequestId,
      rememberDevice: true,
    );

    expect(loginBody['email'], 'rajesh.gowda@example.com');
    expect(loginBody['otp'], '123456');
    expect(loginBody['otpRequestId'], 'otp_req_login_01');
    expect(storage.accessToken, 'access-token');
    expect(storage.refreshToken, 'refresh-token');
    expect(authNotifier.state.status, AuthStatus.authenticated);
  });

  test('sign-up OTP uses the Swagger signUp purpose value', () async {
    late Map<String, dynamic> body;
    final api = ApiService(
      client: MockClient((request) async {
        body = jsonDecode(request.body) as Map<String, dynamic>;
        return _jsonResponse({
          'success': true,
          'message': 'Verification code sent successfully',
          'data': {
            'otpRequestId': 'otp_req_signup_01',
            'expiresInSeconds': 300,
            'resendAfterSeconds': 30,
          },
        });
      }),
      tokenStorage: _MemoryTokenStorage(),
    );

    final notifier = OtpNotifier(api);
    await notifier.sendOtp(
      const PendingSignup(
        fullName: 'Test User',
        email: ' TEST@EXAMPLE.COM ',
        pan: 'ABCDE1234F',
        entityType: 'Sole Proprietorship',
      ),
    );

    expect(body['email'], 'test@example.com');
    expect(body['purpose'], 'signUp');
    expect(notifier.state.pending?.email, 'test@example.com');
    expect(notifier.state.otpRequestId, 'otp_req_signup_01');
  });
}

http.Response _jsonResponse(Map<String, dynamic> body, {int statusCode = 200}) {
  return http.Response(
    jsonEncode(body),
    statusCode,
    headers: {'content-type': 'application/json'},
  );
}

class _MemoryTokenStorage extends SecureTokenStorage {
  String? accessToken;
  String? refreshToken;

  @override
  Future<String?> readAccessToken() async => accessToken;

  @override
  Future<String?> readRefreshToken() async => refreshToken;

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;
  }

  @override
  Future<void> clear() async {
    accessToken = null;
    refreshToken = null;
  }
}

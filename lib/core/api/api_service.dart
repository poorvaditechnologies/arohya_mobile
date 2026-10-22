import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'api_endpoints.dart';
import 'api_response.dart';

class SecureTokenStorage {
  static const _accessTokenKey = 'arohya_access_token';
  static const _refreshTokenKey = 'arohya_refresh_token';

  final FlutterSecureStorage _storage;

  const SecureTokenStorage({
    FlutterSecureStorage storage = const FlutterSecureStorage(),
  }) : _storage = storage;

  Future<String?> readAccessToken() => _storage.read(key: _accessTokenKey);

  Future<String?> readRefreshToken() => _storage.read(key: _refreshTokenKey);

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      _storage.write(key: _accessTokenKey, value: accessToken),
      _storage.write(key: _refreshTokenKey, value: refreshToken),
    ]);
  }

  Future<void> clear() async {
    await Future.wait([
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _refreshTokenKey),
    ]);
  }
}

class ApiService {
  static const String baseUrl = 'https://arohya-api.onrender.com';
  static const Duration defaultTimeout = Duration(seconds: 30);

  /// Authentication can include a Render cold start and an SMTP send. The
  /// live OTP endpoint can legitimately take longer than the normal API
  /// timeout, so auth callers opt into this larger window.
  static const Duration authenticationTimeout = Duration(minutes: 3);

  final http.Client _client;
  final SecureTokenStorage tokenStorage;
  Future<bool>? _refreshInProgress;

  ApiService({http.Client? client, SecureTokenStorage? tokenStorage})
    : _client = client ?? http.Client(),
      tokenStorage = tokenStorage ?? const SecureTokenStorage();

  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, Object?>? queryParameters,
    bool authenticated = true,
    String languageCode = 'en',
    T Function(Object? json)? decodeData,
    Duration timeout = defaultTimeout,
  }) {
    return _request<T>(
      'GET',
      endpoint,
      queryParameters: queryParameters,
      authenticated: authenticated,
      languageCode: languageCode,
      decodeData: decodeData,
      timeout: timeout,
    );
  }

  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Object? body,
    bool authenticated = true,
    String languageCode = 'en',
    T Function(Object? json)? decodeData,
    Duration timeout = defaultTimeout,
  }) {
    return _request<T>(
      'POST',
      endpoint,
      body: body,
      authenticated: authenticated,
      languageCode: languageCode,
      decodeData: decodeData,
      timeout: timeout,
    );
  }

  Future<ApiResponse<T>> patch<T>(
    String endpoint, {
    Object? body,
    bool authenticated = true,
    String languageCode = 'en',
    T Function(Object? json)? decodeData,
    Duration timeout = defaultTimeout,
  }) {
    return _request<T>(
      'PATCH',
      endpoint,
      body: body,
      authenticated: authenticated,
      languageCode: languageCode,
      decodeData: decodeData,
      timeout: timeout,
    );
  }

  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    Object? body,
    bool authenticated = true,
    String languageCode = 'en',
    T Function(Object? json)? decodeData,
    Duration timeout = defaultTimeout,
  }) {
    return _request<T>(
      'DELETE',
      endpoint,
      body: body,
      authenticated: authenticated,
      languageCode: languageCode,
      decodeData: decodeData,
      timeout: timeout,
    );
  }

  /// Uploads bytes to a backend-issued presigned URL. The URL is used as-is;
  /// the Arohya base URL and bearer token must not be added to S3 requests.
  Future<void> putBytes(
    String presignedUrl, {
    required Uint8List bytes,
    required String contentType,
  }) async {
    try {
      final response = await _client
          .put(
            Uri.parse(presignedUrl),
            headers: {'Content-Type': contentType},
            body: bytes,
          )
          .timeout(defaultTimeout);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ApiException(
          message: 'File upload failed',
          statusCode: response.statusCode,
        );
      }
    } on TimeoutException {
      throw const ApiException(message: 'The upload timed out. Please retry.');
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const ApiException(
        message: 'Unable to upload the file. Check your connection.',
      );
    }
  }

  Future<ApiResponse<T>> _request<T>(
    String method,
    String endpoint, {
    Object? body,
    Map<String, Object?>? queryParameters,
    required bool authenticated,
    required String languageCode,
    required T Function(Object? json)? decodeData,
    required Duration timeout,
    bool allowRefresh = true,
  }) async {
    try {
      var response = await _send(
        method,
        endpoint,
        body: body,
        queryParameters: queryParameters,
        authenticated: authenticated,
        languageCode: languageCode,
        timeout: timeout,
      );

      if (response.statusCode == 401 && authenticated && allowRefresh) {
        final refreshed = await _refreshAccessToken();
        if (refreshed) {
          response = await _send(
            method,
            endpoint,
            body: body,
            queryParameters: queryParameters,
            authenticated: true,
            languageCode: languageCode,
            timeout: timeout,
          );
        }
      }

      return _decodeResponse(response, decodeData);
    } on TimeoutException {
      throw const ApiException(
        message: 'The request timed out. Please try again.',
      );
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const ApiException(
        message: 'Unable to connect. Check your internet connection.',
      );
    }
  }

  Future<http.Response> _send(
    String method,
    String endpoint, {
    Object? body,
    Map<String, Object?>? queryParameters,
    required bool authenticated,
    required String languageCode,
    required Duration timeout,
  }) async {
    final request = http.Request(method, _buildUri(endpoint, queryParameters));
    request.headers.addAll({
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Accept-Language': languageCode,
    });

    if (authenticated) {
      final accessToken = await tokenStorage.readAccessToken();
      if (accessToken != null && accessToken.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $accessToken';
      }
    }
    if (body != null) request.body = jsonEncode(body);

    final streamed = await _client.send(request).timeout(timeout);
    return http.Response.fromStream(streamed).timeout(timeout);
  }

  Uri _buildUri(String endpoint, Map<String, Object?>? queryParameters) {
    final normalized = endpoint.startsWith('/') ? endpoint : '/$endpoint';
    final uri = Uri.parse('$baseUrl$normalized');
    if (queryParameters == null || queryParameters.isEmpty) return uri;
    return uri.replace(
      queryParameters: {
        for (final entry in queryParameters.entries)
          if (entry.value != null) entry.key: entry.value.toString(),
      },
    );
  }

  ApiResponse<T> _decodeResponse<T>(
    http.Response response,
    T Function(Object? json)? decodeData,
  ) {
    JsonMap json;
    try {
      final decoded = response.bodyBytes.isEmpty
          ? <String, dynamic>{
              'success':
                  response.statusCode >= 200 && response.statusCode < 300,
              'message': '',
              'data': null,
            }
          : jsonDecode(utf8.decode(response.bodyBytes)) as Object?;
      json = decoded is Map
          ? decoded.cast<String, dynamic>()
          : <String, dynamic>{
              'success':
                  response.statusCode >= 200 && response.statusCode < 300,
              'message': '',
              'data': decoded,
            };
    } catch (_) {
      throw ApiException(
        message: 'The server returned an unreadable response.',
        statusCode: response.statusCode,
      );
    }

    final apiResponse = ApiResponse<T>.fromJson(json, decodeData: decodeData);
    if (response.statusCode < 200 ||
        response.statusCode >= 300 ||
        !apiResponse.success) {
      throw ApiException(
        message: apiResponse.message.isEmpty
            ? 'Request failed (${response.statusCode})'
            : apiResponse.message,
        statusCode: response.statusCode,
        errors: apiResponse.errors,
        requestId: apiResponse.requestId,
      );
    }
    return apiResponse;
  }

  Future<bool> _refreshAccessToken() {
    return _refreshInProgress ??= _performTokenRefresh().whenComplete(() {
      _refreshInProgress = null;
    });
  }

  Future<bool> _performTokenRefresh() async {
    final refreshToken = await tokenStorage.readRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) return false;

    try {
      final response = await _request<JsonMap>(
        'POST',
        ApiEndpoints.refreshToken,
        body: {'refreshToken': refreshToken},
        authenticated: false,
        languageCode: 'en',
        decodeData: (json) => (json as Map).cast<String, dynamic>(),
        timeout: authenticationTimeout,
        allowRefresh: false,
      );
      final data = response.data;
      final accessToken = data?['accessToken'] as String?;
      final newRefreshToken = data?['refreshToken'] as String?;
      if (accessToken == null || newRefreshToken == null) return false;
      await tokenStorage.saveTokens(
        accessToken: accessToken,
        refreshToken: newRefreshToken,
      );
      return true;
    } catch (_) {
      await tokenStorage.clear();
      return false;
    }
  }

  void close() => _client.close();
}

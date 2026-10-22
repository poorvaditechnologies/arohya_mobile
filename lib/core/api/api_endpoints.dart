/// Versioned API paths.
///
/// [ApiService.baseUrl] intentionally contains only the host so individual
/// endpoints can move between API versions independently.
abstract final class ApiEndpoints {
  static const generateOtp = '/api/v1/generate-otp';
  static const login = '/api/v1/login';
  static const signUp = '/api/v1/sign-up';
  static const refreshToken = '/api/v1/auth/refresh-token';
  static const logout = '/api/v1/auth/logout';

  static const financingSolutions = '/api/v1/financing-solutions';
  static const applications = '/api/v1/applications';
  static String application(String id) => '$applications/$id';

  static const uploadUrl = '/api/v1/files/upload-url';
  static String confirmUpload(String attachmentId) =>
      '/api/v1/files/$attachmentId/confirm';
  static String attachment(String attachmentId) =>
      '/api/v1/files/$attachmentId';

  static const dashboard = '/api/v1/dashboard';
  static const loanFacilities = '/api/v1/loan-facilities';
  static const profile = '/api/v1/profile';
  static const profilePreferences = '/api/v1/profile/preferences';
  static const support = '/api/v1/support';
  static const callbackRequests = '/api/v1/support/callback-requests';
  static const notifications = '/api/v1/notifications';
  static String markNotificationRead(String notificationId) =>
      '/api/v1/notifications/$notificationId/read';
}

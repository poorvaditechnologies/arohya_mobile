typedef JsonMap = Map<String, dynamic>;

class ApiFieldError {
  final String? field;
  final String? code;
  final String message;

  const ApiFieldError({this.field, this.code, required this.message});

  factory ApiFieldError.fromJson(JsonMap json) {
    return ApiFieldError(
      field: json['field'] as String?,
      code: json['code'] as String?,
      message: json['message'] as String? ?? 'Something went wrong',
    );
  }
}

/// Standard response envelope returned by the Arohya API.
class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final List<ApiFieldError> errors;
  final String? requestId;

  const ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.errors = const [],
    this.requestId,
  });

  factory ApiResponse.fromJson(
    JsonMap json, {
    T Function(Object? json)? decodeData,
  }) {
    final rawErrors = json['errors'];
    return ApiResponse<T>(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: decodeData == null || json['data'] == null
          ? json['data'] as T?
          : decodeData(json['data']),
      errors: rawErrors is List
          ? rawErrors
                .whereType<Map>()
                .map(
                  (item) =>
                      ApiFieldError.fromJson(item.cast<String, dynamic>()),
                )
                .toList(growable: false)
          : const [],
      requestId: json['requestId'] as String?,
    );
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final List<ApiFieldError> errors;
  final String? requestId;

  const ApiException({
    required this.message,
    this.statusCode,
    this.errors = const [],
    this.requestId,
  });

  String? get firstFieldMessage => errors.isEmpty ? null : errors.first.message;

  @override
  String toString() => firstFieldMessage ?? message;
}

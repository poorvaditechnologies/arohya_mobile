import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  final service = ApiService();
  ref.onDispose(service.close);
  return service;
});

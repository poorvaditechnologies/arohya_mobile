import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_endpoints.dart';
import '../../../core/api/api_provider.dart';
import '../../../core/api/api_response.dart';
import '../../../core/api/api_service.dart';
import '../models/loan_application_model.dart';

class ApplyLoanNotifier extends StateNotifier<ApplyLoanState> {
  final ApiService _api;

  ApplyLoanNotifier(this._api, String? initialProductId)
    : super(ApplyLoanState(productId: initialProductId));

  void setProductId(String? productId) {
    state = ApplyLoanState(
      productId: productId,
      sameAsPermanent: state.sameAsPermanent,
      status: state.status,
    );
  }

  void setSameAsPermanent(bool value) {
    state = state.copyWith(sameAsPermanent: value);
  }

  Future<String> submit(LoanApplicationModel application) async {
    state = state.copyWith(status: ApplyLoanStatus.submitting);
    try {
      final response = await _api.post<JsonMap>(
        ApiEndpoints.applications,
        body: application.toJson(),
        decodeData: (json) => (json as Map).cast<String, dynamic>(),
      );
      if (mounted) state = state.copyWith(status: ApplyLoanStatus.submitted);
      return response.data?['applicationNumber'] as String? ?? '';
    } catch (_) {
      if (mounted) state = state.copyWith(status: ApplyLoanStatus.idle);
      rethrow;
    }
  }
}

final applyLoanProvider = StateNotifierProvider.autoDispose
    .family<ApplyLoanNotifier, ApplyLoanState, String?>((ref, productId) {
      return ApplyLoanNotifier(ref.watch(apiServiceProvider), productId);
    });

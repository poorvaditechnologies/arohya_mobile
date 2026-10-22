/// Details submitted to the generic product application endpoint.
class LoanApplicationModel {
  final String productId;
  final String firstName;
  final String lastName;
  final String mobile;
  final String permanentAddress;
  final String temporaryAddress;
  final String email;
  final double? income;
  final DateTime? loanNeededDate;

  const LoanApplicationModel({
    required this.productId,
    required this.firstName,
    required this.lastName,
    required this.mobile,
    required this.permanentAddress,
    required this.temporaryAddress,
    required this.email,
    this.income,
    this.loanNeededDate,
  });

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'firstName': firstName,
    'lastName': lastName,
    'mobile': mobile,
    'permanentAddress': _addressJson(permanentAddress),
    'temporaryAddress': {
      ..._addressJson(temporaryAddress),
      'sameAsPermanent': temporaryAddress == permanentAddress,
    },
    if (email.isNotEmpty) 'email': email,
    if (income != null) 'income': income,
    if (loanNeededDate != null)
      'loanNeededDate': loanNeededDate!.toIso8601String().split('T').first,
  };

  factory LoanApplicationModel.fromJson(Map<String, dynamic> json) {
    return LoanApplicationModel(
      productId: json['productId'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      mobile: json['mobile'] as String? ?? '',
      permanentAddress: _addressLine(json['permanentAddress']),
      temporaryAddress: _addressLine(json['temporaryAddress']),
      email: json['email'] as String? ?? '',
      income: (json['income'] as num?)?.toDouble(),
      loanNeededDate: DateTime.tryParse(
        json['loanNeededDate'] as String? ?? '',
      ),
    );
  }

  // The current UI collects a complete address in one field. These keys match
  // the API contract and leave structured fields ready for a future UI split.
  static Map<String, dynamic> _addressJson(String address) => {
    'addressLine': address,
    'city': '',
    'state': '',
    'postalCode': '',
    'country': 'IN',
  };

  static String _addressLine(Object? address) {
    if (address is String) return address;
    if (address is Map) return address['addressLine'] as String? ?? '';
    return '';
  }
}

enum ApplyLoanStatus { idle, submitting, submitted }

class ApplyLoanState {
  final String? productId;
  final bool sameAsPermanent;
  final ApplyLoanStatus status;

  const ApplyLoanState({
    this.productId,
    this.sameAsPermanent = false,
    this.status = ApplyLoanStatus.idle,
  });

  ApplyLoanState copyWith({
    String? productId,
    bool? sameAsPermanent,
    ApplyLoanStatus? status,
  }) {
    return ApplyLoanState(
      productId: productId ?? this.productId,
      sameAsPermanent: sameAsPermanent ?? this.sameAsPermanent,
      status: status ?? this.status,
    );
  }
}

/// Data model representing a loan or credit facility.
class LoanFacilityModel {
  final String id;
  final String title;
  final double sanctionedAmount;
  final double nextEmiAmount;
  final String nextEmiDate;
  final String status;
  final String currency;
  final bool autoDebitActive;

  const LoanFacilityModel({
    required this.id,
    required this.title,
    required this.sanctionedAmount,
    required this.nextEmiAmount,
    required this.nextEmiDate,
    required this.status,
    this.currency = 'INR',
    this.autoDebitActive = true,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'sanctionedAmount': sanctionedAmount,
    'nextEmiAmount': nextEmiAmount,
    'nextEmiDate': nextEmiDate,
    'status': status,
    'currency': currency,
    'autoDebitActive': autoDebitActive,
  };

  factory LoanFacilityModel.fromJson(Map<String, dynamic> json) {
    return LoanFacilityModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'Credit Facility',
      sanctionedAmount: (json['sanctionedAmount'] as num?)?.toDouble() ?? 0.0,
      nextEmiAmount: (json['nextEmiAmount'] as num?)?.toDouble() ?? 0.0,
      nextEmiDate: json['nextEmiDate'] as String? ?? '',
      status:
          json['statusLabel'] as String? ??
          json['status'] as String? ??
          'Active',
      currency: json['currency'] as String? ?? 'INR',
      autoDebitActive: json['autoDebitActive'] as bool? ?? true,
    );
  }
}

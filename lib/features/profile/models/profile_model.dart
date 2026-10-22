class ProfileModel {
  final String id;
  final String fullName;
  final String email;
  final String mobileNumber;
  final String? avatarUrl;
  final String businessType;
  final String panMasked;
  final String gstinStatus;
  final String gstinMasked;
  final String accountAggregatorStatus;
  final String accountAggregatorHandle;
  final String kycStatus;
  final bool biometricEnabled;

  const ProfileModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.mobileNumber,
    this.avatarUrl,
    required this.businessType,
    required this.panMasked,
    required this.gstinStatus,
    required this.gstinMasked,
    required this.accountAggregatorStatus,
    required this.accountAggregatorHandle,
    required this.kycStatus,
    required this.biometricEnabled,
  });

  ProfileModel copyWith({bool? biometricEnabled}) {
    return ProfileModel(
      id: id,
      fullName: fullName,
      email: email,
      mobileNumber: mobileNumber,
      avatarUrl: avatarUrl,
      businessType: businessType,
      panMasked: panMasked,
      gstinStatus: gstinStatus,
      gstinMasked: gstinMasked,
      accountAggregatorStatus: accountAggregatorStatus,
      accountAggregatorHandle: accountAggregatorHandle,
      kycStatus: kycStatus,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
    );
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final aggregator = json['accountAggregator'] is Map
        ? (json['accountAggregator'] as Map).cast<String, dynamic>()
        : const <String, dynamic>{};
    final preferences = json['preferences'] is Map
        ? (json['preferences'] as Map).cast<String, dynamic>()
        : const <String, dynamic>{};
    return ProfileModel(
      id: json['id'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      mobileNumber: json['mobileNumber'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String?,
      businessType: json['businessType'] as String? ?? '',
      panMasked: json['panMasked'] as String? ?? '',
      gstinStatus: json['gstinStatus'] as String? ?? '',
      gstinMasked: json['gstinMasked'] as String? ?? '',
      accountAggregatorStatus: aggregator['status'] as String? ?? '',
      accountAggregatorHandle: aggregator['handle'] as String? ?? '',
      kycStatus: json['kycStatus'] as String? ?? '',
      biometricEnabled: preferences['biometricEnabled'] as bool? ?? false,
    );
  }
}

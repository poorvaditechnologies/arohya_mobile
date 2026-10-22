/// Represents an active credit application.
class ApplicationModel {
  final String id;
  final String applicationNumber;
  final String facilityName;
  final double requestedAmount;
  final String status;
  final int currentStep;
  final int totalSteps;

  const ApplicationModel({
    this.id = '',
    required this.applicationNumber,
    required this.facilityName,
    required this.requestedAmount,
    required this.status,
    required this.currentStep,
    required this.totalSteps,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'applicationNumber': applicationNumber,
    'facilityName': facilityName,
    'requestedAmount': requestedAmount,
    'status': status,
    'currentStep': currentStep,
    'totalSteps': totalSteps,
  };

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    return ApplicationModel(
      id: json['id'] as String? ?? '',
      applicationNumber: json['applicationNumber'] as String? ?? '',
      facilityName:
          json['productTitle'] as String? ??
          json['facilityName'] as String? ??
          '',
      requestedAmount: (json['requestedAmount'] as num?)?.toDouble() ?? 0.0,
      status: json['statusLabel'] as String? ?? json['status'] as String? ?? '',
      currentStep: json['currentStep'] as int? ?? 1,
      totalSteps: json['totalSteps'] as int? ?? 4,
    );
  }
}

class DashboardModel {
  final String firstName;
  final String kycStatus;
  final String tierLabel;
  final ApplicationModel? activeApplication;
  final int unreadNotificationCount;

  const DashboardModel({
    required this.firstName,
    required this.kycStatus,
    required this.tierLabel,
    this.activeApplication,
    required this.unreadNotificationCount,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    final user = (json['user'] as Map?)?.cast<String, dynamic>() ?? const {};
    final application = json['activeApplication'];
    return DashboardModel(
      firstName: user['firstName'] as String? ?? '',
      kycStatus: user['kycStatus'] as String? ?? '',
      tierLabel: user['tierLabel'] as String? ?? '',
      activeApplication: application is Map
          ? ApplicationModel.fromJson(application.cast<String, dynamic>())
          : null,
      unreadNotificationCount: json['unreadNotificationCount'] as int? ?? 0,
    );
  }
}

/// Represents a credit financing solution category.
class FinancingSolutionModel {
  final String title;
  final String description;
  final String ticketSize;
  final String badge;
  final String iconName;

  const FinancingSolutionModel({
    required this.title,
    required this.description,
    required this.ticketSize,
    required this.badge,
    required this.iconName,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'ticketSize': ticketSize,
    'badge': badge,
    'iconName': iconName,
  };

  factory FinancingSolutionModel.fromJson(Map<String, dynamic> json) {
    return FinancingSolutionModel(
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      ticketSize: json['ticketSize'] as String? ?? '',
      badge: json['badge'] as String? ?? '',
      iconName: json['iconName'] as String? ?? '',
    );
  }
}

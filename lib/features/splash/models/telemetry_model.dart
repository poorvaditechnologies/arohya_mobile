/// Telemetry data model for system initialization steps.
class TelemetryModel {
  final int step;
  final String message;
  final bool isCompleted;

  const TelemetryModel({
    required this.step,
    required this.message,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() => {
        'step': step,
        'message': message,
        'isCompleted': isCompleted,
      };

  factory TelemetryModel.fromJson(Map<String, dynamic> json) {
    return TelemetryModel(
      step: json['step'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }
}

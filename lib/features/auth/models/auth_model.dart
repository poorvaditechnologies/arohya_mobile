/// Authentication lifecycle statuses.
enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

/// Represents an authenticated borrower/user entity.
class UserModel {
  final String id;
  final String name;
  final String mobileNumber;
  final String? email;
  final String? pan;
  final String? entityType;
  final String? kycStatus;

  const UserModel({
    required this.id,
    required this.name,
    this.mobileNumber = '',
    this.email,
    this.pan,
    this.entityType,
    this.kycStatus,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'mobileNumber': mobileNumber,
    'email': email,
    'pan': pan,
    'entityType': entityType,
    'kycStatus': kycStatus,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      name: json['fullName'] as String? ?? json['name'] as String? ?? '',
      mobileNumber: json['mobileNumber'] as String? ?? '',
      email: json['email'] as String?,
      pan: json['panMasked'] as String? ?? json['pan'] as String?,
      entityType: json['entityType'] as String?,
      kycStatus: json['kycStatus'] as String?,
    );
  }
}

/// Signup details collected on the signup form, held until the email OTP is
/// verified and the account can actually be created.
class PendingSignup {
  final String fullName;
  final String email;
  final String pan;
  final String entityType;
  final String? advisorCode;

  const PendingSignup({
    required this.fullName,
    required this.email,
    required this.pan,
    required this.entityType,
    this.advisorCode,
  });
}

/// Lifecycle of the email OTP challenge.
enum OtpStatus { idle, sending, sent, verifying, verified, failed }

/// What a successful OTP verification should do.
enum OtpPurpose { signup, login }

/// State of the email OTP verification step.
class OtpState {
  final OtpStatus status;
  final OtpPurpose purpose;

  /// Address the code was sent to. Empty until a code has been requested.
  final String email;

  /// Server-issued identifier that binds verification to one OTP challenge.
  final String otpRequestId;

  final int expiresInSeconds;
  final int resendAfterSeconds;

  /// Signup details to submit after verification (signup purpose only).
  final PendingSignup? pending;

  const OtpState({
    this.status = OtpStatus.idle,
    this.purpose = OtpPurpose.signup,
    this.email = '',
    this.otpRequestId = '',
    this.expiresInSeconds = 300,
    this.resendAfterSeconds = 30,
    this.pending,
  });

  OtpState copyWith({
    OtpStatus? status,
    String? otpRequestId,
    int? expiresInSeconds,
    int? resendAfterSeconds,
  }) {
    return OtpState(
      status: status ?? this.status,
      purpose: purpose,
      email: email,
      otpRequestId: otpRequestId ?? this.otpRequestId,
      expiresInSeconds: expiresInSeconds ?? this.expiresInSeconds,
      resendAfterSeconds: resendAfterSeconds ?? this.resendAfterSeconds,
      pending: pending,
    );
  }
}

/// Global authentication state.
class AuthState {
  final AuthStatus status;
  final String? errorMessage;
  final String? userName;
  final String? mobileNumber;
  final String? email;
  final UserModel? user;

  const AuthState({
    this.status = AuthStatus.initial,
    this.errorMessage,
    this.userName,
    this.mobileNumber,
    this.email,
    this.user,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
    String? userName,
    String? mobileNumber,
    String? email,
    UserModel? user,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      userName: userName ?? this.userName,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      email: email ?? this.email,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status.name,
    'errorMessage': errorMessage,
    'userName': userName,
    'mobileNumber': mobileNumber,
    'email': email,
    'user': user?.toJson(),
  };

  factory AuthState.fromJson(Map<String, dynamic> json) {
    return AuthState(
      status: AuthStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => AuthStatus.initial,
      ),
      errorMessage: json['errorMessage'] as String?,
      userName: json['userName'] as String?,
      mobileNumber: json['mobileNumber'] as String?,
      email: json['email'] as String?,
      user: json['user'] != null
          ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }
}

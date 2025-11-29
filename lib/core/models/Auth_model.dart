class AuthResponse {
  final String message;
  final UserModel user;
  final String token;

  AuthResponse({
    required this.message,
    required this.user,
    required this.token,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      message: json['message'] ?? '',
      user: UserModel.fromJson(json['user']),
      token: json['token'] ?? '',
    );
  }
}

class ProfileResponse {
  final bool status;
  final String message;
  final UserModel user;

  ProfileResponse({
    required this.status,
    required this.message,
    required this.user,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      user: UserModel.fromJson(json['user']),
    );
  }
}

class UserModel {
  final int id;
  final String name;
  final String email;
  final String? emailVerifiedAt;
  final String authType;
  final String? googleId;
  final String? appleId;
  final String? deviceToken;
  final String? avatar;
  final String? phone;
  final String? dob;
  final String? gender;
  final String role;
  final String status;
  final String createdAt;
  final String updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    required this.authType,
    this.googleId,
    this.appleId,
    this.deviceToken,
    this.avatar,
    this.phone,
    this.dob,
    this.gender,
    required this.role,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      emailVerifiedAt: json['email_verified_at'],
      authType: json['auth_type'] ?? '',
      googleId: json['google_id'],
      appleId: json['apple_id'],
      deviceToken: json['device_token'],
      avatar: json['avatar'],
      phone: json['phone'],
      dob: json['dob'],
      gender: json['gender'],
      role: json['role'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

class AuthResponse {
  final bool success;
  final String message;
  final AuthData data;

  AuthResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: AuthData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class AuthData {
  final User user;
  final String token;

  AuthData({required this.user, required this.token});

  factory AuthData.fromJson(Map<String, dynamic> json) {
    return AuthData(
      user: User.fromJson(json['user'] ?? {}),
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'token': token,
    };
  }
}

class User {
  final String role;
  final String name;
  final String email;
  final String phone;
  final String? profilePhoto;
  final String updatedAt;
  final String createdAt;
  final int id;

  User({
    required this.role,
    required this.name,
    required this.email,
    required this.phone,
    this.profilePhoto,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      role: json['role'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      profilePhoto: json['profile_photo'],
      updatedAt: json['updated_at'] ?? '',
      createdAt: json['created_at'] ?? '',
      id: json['id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'name': name,
      'email': email,
      'phone': phone,
      'profile_photo': profilePhoto,
      'updated_at': updatedAt,
      'created_at': createdAt,
      'id': id,
    };
  }
}
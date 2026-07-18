import '../../domain/entities/auth_session.dart';

class AuthSessionModel extends AuthSession {
  const AuthSessionModel({required super.type, required super.token});

  factory AuthSessionModel.fromJson(final Map<String, dynamic> json) {
    return AuthSessionModel(
      type: json['type'] as String,
      token: json['token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'token': token};
  }

  AuthSessionModel copyWith({final String? type, final String? token}) {
    return AuthSessionModel(
      type: type ?? this.type,
      token: token ?? this.token,
    );
  }
}

import 'package:kerb/src/features/auth/domain/entities/auth_session.dart';

class AuthSessionModel {
  const AuthSessionModel({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresInSeconds,
    required this.accountId,
  });

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    return AuthSessionModel(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      expiresInSeconds: json['expires_in'] as int,
      accountId: json['account_id'] as String,
    );
  }

  final String accessToken;
  final String refreshToken;
  final int expiresInSeconds;
  final String accountId;

  AuthSession toEntity(DateTime now) {
    return AuthSession(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: now.add(Duration(seconds: expiresInSeconds)),
      accountId: accountId,
    );
  }
}

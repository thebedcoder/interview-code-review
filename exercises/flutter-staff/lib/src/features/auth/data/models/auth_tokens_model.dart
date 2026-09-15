import 'package:fieldops/src/features/auth/domain/entities/auth_tokens.dart';

/// Wire format for the `/auth` endpoints. Stays inside the data layer - the
/// repository maps it to [AuthTokens] before anything else sees it.
class AuthTokensModel {
  const AuthTokensModel({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresInSeconds,
  });

  factory AuthTokensModel.fromJson(Map<String, dynamic> json) {
    return AuthTokensModel(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      expiresInSeconds: json['expires_in'] as int,
    );
  }

  final String accessToken;
  final String refreshToken;
  final int expiresInSeconds;

  AuthTokens toEntity(DateTime now) {
    return AuthTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: now.add(Duration(seconds: expiresInSeconds)),
    );
  }
}

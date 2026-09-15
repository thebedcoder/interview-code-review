import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persists the session.
///
/// Both tokens are long-lived credentials, so they live in the platform
/// keychain / keystore and never in plain preferences or the database.
class TokenLocalDataSource {
  const TokenLocalDataSource(this._storage);

  static const String _accessTokenKey = 'auth.access_token';
  static const String _refreshTokenKey = 'auth.refresh_token';
  static const String _expiresAtKey = 'auth.expires_at';

  final FlutterSecureStorage _storage;

  Future<void> save({
    required String accessToken,
    required String refreshToken,
    required DateTime expiresAt,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
    await _storage.write(
      key: _expiresAtKey,
      value: expiresAt.toUtc().toIso8601String(),
    );
  }

  Future<String?> readAccessToken() => _storage.read(key: _accessTokenKey);

  Future<String?> readRefreshToken() => _storage.read(key: _refreshTokenKey);

  Future<DateTime?> readExpiresAt() async {
    final String? raw = await _storage.read(key: _expiresAtKey);
    return raw == null ? null : DateTime.parse(raw);
  }

  Future<void> clear() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _expiresAtKey);
  }
}

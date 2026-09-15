import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Holds the session and the in-flight PKCE values.
///
/// Everything here is a credential, so it all goes to the keychain / Android
/// keystore. `encryptedSharedPreferences` is the Keystore-backed Android
/// implementation, not plain preferences.
class AuthLocalDataSource {
  AuthLocalDataSource()
    : _storage = const FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
      );

  static const String _accessTokenKey = 'auth.access';
  static const String _refreshTokenKey = 'auth.refresh';
  static const String _expiresAtKey = 'auth.expires_at';
  static const String _accountIdKey = 'auth.account_id';
  static const String _verifierKey = 'auth.pkce_verifier';
  static const String _stateKey = 'auth.pkce_state';

  final FlutterSecureStorage _storage;

  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    required DateTime expiresAt,
    required String accountId,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
    await _storage.write(key: _accountIdKey, value: accountId);
    await _storage.write(
      key: _expiresAtKey,
      value: expiresAt.toUtc().toIso8601String(),
    );
  }

  Future<void> savePending({
    required String verifier,
    required String state,
  }) async {
    await _storage.write(key: _verifierKey, value: verifier);
    await _storage.write(key: _stateKey, value: state);
  }

  Future<String?> readPendingVerifier() => _storage.read(key: _verifierKey);

  Future<String?> readPendingState() => _storage.read(key: _stateKey);

  Future<void> clearPending() async {
    await _storage.delete(key: _verifierKey);
    await _storage.delete(key: _stateKey);
  }

  Future<String?> readAccessToken() => _storage.read(key: _accessTokenKey);

  Future<String?> readRefreshToken() => _storage.read(key: _refreshTokenKey);

  Future<String?> readAccountId() => _storage.read(key: _accountIdKey);

  Future<DateTime?> readExpiresAt() async {
    final String? raw = await _storage.read(key: _expiresAtKey);
    return raw == null ? null : DateTime.parse(raw);
  }

  Future<void> clearSession() async {
    await _storage.deleteAll();
  }
}

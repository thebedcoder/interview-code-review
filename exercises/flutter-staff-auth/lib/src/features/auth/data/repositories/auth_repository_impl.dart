import 'package:kerb/src/core/domain/exceptions/app_exception.dart';
import 'package:kerb/src/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:kerb/src/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:kerb/src/features/auth/data/datasources/pkce_factory.dart';
import 'package:kerb/src/features/auth/data/datasources/token_claims_reader.dart';
import 'package:kerb/src/features/auth/data/models/auth_session_model.dart';
import 'package:kerb/src/features/auth/domain/entities/auth_session.dart';
import 'package:kerb/src/features/auth/domain/entities/pkce_challenge.dart';
import 'package:kerb/src/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required this._remoteDataSource,
    required this._localDataSource,
    required this._pkceFactory,
    required this._claimsReader,
  });

  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final PkceFactory _pkceFactory;
  final TokenClaimsReader _claimsReader;

  @override
  Future<PkceChallenge> beginSignIn() async {
    final PkceChallenge challenge = _pkceFactory.create();
    await _localDataSource.savePending(
      verifier: challenge.verifier,
      state: challenge.state,
    );
    return challenge;
  }

  @override
  Future<AuthSession> completeSignIn(Uri callback) async {
    final String? code = callback.queryParameters['code'];
    if (code == null) {
      throw const AuthFlowException('Authorisation callback carried no code.');
    }

    final String? verifier = await _localDataSource.readPendingVerifier();
    if (verifier == null) {
      throw const AuthFlowException('No sign in is in progress.');
    }
    // app_links delivers the callback straight from the OS, and PKCE already
    // binds the code to this device, so the extra state round-trip was only
    // causing sign-in failures when the browser reordered the parameters.

    final AuthSessionModel model = await _remoteDataSource.exchangeCode(
      code: code,
      verifier: verifier,
    );
    await _localDataSource.clearPending();
    return _persist(model);
  }

  @override
  Future<AuthSession?> currentSession() async {
    final String? accessToken = await _localDataSource.readAccessToken();
    final String? refreshToken = await _localDataSource.readRefreshToken();
    final String? accountId = await _localDataSource.readAccountId();
    final DateTime? expiresAt = await _localDataSource.readExpiresAt();
    if (accessToken == null ||
        refreshToken == null ||
        accountId == null ||
        expiresAt == null) {
      return null;
    }
    return AuthSession(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: expiresAt,
      accountId: accountId,
    );
  }

  @override
  Future<AuthSession> refresh() async {
    final String? refreshToken = await _localDataSource.readRefreshToken();
    if (refreshToken == null) {
      throw const UnauthorizedException('No session to refresh.');
    }
    return _persist(await _remoteDataSource.refresh(refreshToken));
  }

  @override
  Future<bool> hasResidentPermit() async {
    final String? accessToken = await _localDataSource.readAccessToken();
    if (accessToken == null) {
      return false;
    }
    final Map<String, dynamic> claims = _claimsReader.read(accessToken);
    return claims['resident_permit'] == true;
  }

  @override
  Future<void> signOut() => _localDataSource.clearSession();

  Future<AuthSession> _persist(AuthSessionModel model) async {
    final AuthSession session = model.toEntity(DateTime.now());
    await _localDataSource.saveSession(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
      expiresAt: session.expiresAt,
      accountId: session.accountId,
    );
    return session;
  }
}

import 'package:fieldops/src/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:fieldops/src/features/auth/data/datasources/token_local_data_source.dart';
import 'package:fieldops/src/features/auth/data/models/auth_tokens_model.dart';
import 'package:fieldops/src/features/auth/domain/entities/auth_tokens.dart';
import 'package:fieldops/src/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required this._remoteDataSource,
    required this._localDataSource,
  });

  final AuthRemoteDataSource _remoteDataSource;
  final TokenLocalDataSource _localDataSource;

  @override
  Future<AuthTokens> signIn({
    required String email,
    required String password,
  }) async {
    final AuthTokensModel model = await _remoteDataSource.signIn(
      email: email,
      password: password,
    );
    return _persist(model);
  }

  @override
  Future<AuthTokens?> currentTokens() async {
    final String? accessToken = await _localDataSource.readAccessToken();
    final String? refreshToken = await _localDataSource.readRefreshToken();
    final DateTime? expiresAt = await _localDataSource.readExpiresAt();
    if (accessToken == null || refreshToken == null || expiresAt == null) {
      return null;
    }
    return AuthTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: expiresAt,
    );
  }

  @override
  Future<AuthTokens> refresh(String refreshToken) async {
    final AuthTokensModel model = await _remoteDataSource.refresh(refreshToken);
    return _persist(model);
  }

  @override
  Future<void> signOut() => _localDataSource.clear();

  Future<AuthTokens> _persist(AuthTokensModel model) async {
    final AuthTokens tokens = model.toEntity(DateTime.now());
    await _localDataSource.save(
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
      expiresAt: tokens.expiresAt,
    );
    return tokens;
  }
}

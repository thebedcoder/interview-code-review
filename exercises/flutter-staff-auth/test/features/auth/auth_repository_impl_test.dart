import 'package:flutter_test/flutter_test.dart';
import 'package:kerb/src/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:kerb/src/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:kerb/src/features/auth/data/datasources/pkce_factory.dart';
import 'package:kerb/src/features/auth/data/datasources/token_claims_reader.dart';
import 'package:kerb/src/features/auth/data/models/auth_session_model.dart';
import 'package:kerb/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class _MockRemote extends Mock implements AuthRemoteDataSource {}

class _MockLocal extends Mock implements AuthLocalDataSource {}

void main() {
  late _MockRemote remote;
  late _MockLocal local;
  late AuthRepositoryImpl repository;

  setUp(() {
    remote = _MockRemote();
    local = _MockLocal();
    repository = AuthRepositoryImpl(
      remoteDataSource: remote,
      localDataSource: local,
      pkceFactory: const PkceFactory(),
      claimsReader: const TokenClaimsReader(),
    );
    when(
      () => local.saveSession(
        accessToken: any(named: 'accessToken'),
        refreshToken: any(named: 'refreshToken'),
        expiresAt: any(named: 'expiresAt'),
        accountId: any(named: 'accountId'),
      ),
    ).thenAnswer((_) async {});
    when(local.clearPending).thenAnswer((_) async {});
  });

  test('exchanges the code when the callback state matches', () async {
    when(local.readPendingState).thenAnswer((_) async => 'expected-state');
    when(local.readPendingVerifier).thenAnswer((_) async => 'verifier');
    when(
      () => remote.exchangeCode(
        code: any(named: 'code'),
        verifier: any(named: 'verifier'),
      ),
    ).thenAnswer(
      (_) async => const AuthSessionModel(
        accessToken: 'at',
        refreshToken: 'rt',
        expiresInSeconds: 3600,
        accountId: 'acct-1',
      ),
    );

    final session = await repository.completeSignIn(
      Uri.parse('kerb://auth/callback?code=abc&state=expected-state'),
    );

    expect(session.accountId, 'acct-1');
    verify(() => remote.exchangeCode(code: 'abc', verifier: 'verifier'))
        .called(1);
  });

}

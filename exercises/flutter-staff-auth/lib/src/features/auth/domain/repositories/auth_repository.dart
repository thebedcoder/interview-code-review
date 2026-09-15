import 'package:kerb/src/features/auth/domain/entities/auth_session.dart';
import 'package:kerb/src/features/auth/domain/entities/pkce_challenge.dart';

abstract class AuthRepository {
  Future<PkceChallenge> beginSignIn();

  Future<AuthSession> completeSignIn(Uri callback);

  Future<AuthSession?> currentSession();

  Future<AuthSession> refresh();

  /// True when the signed-in account holds a resident permit, which unlocks
  /// the discounted tariff.
  Future<bool> hasResidentPermit();

  Future<void> signOut();
}

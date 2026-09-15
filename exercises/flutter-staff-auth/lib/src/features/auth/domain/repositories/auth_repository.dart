import 'package:kerb/src/features/auth/domain/entities/auth_session.dart';
import 'package:kerb/src/features/auth/domain/entities/pkce_challenge.dart';

abstract class AuthRepository {
  Future<PkceChallenge> beginSignIn();

  Future<AuthSession> completeSignIn(Uri callback);

  Future<AuthSession?> currentSession();

  Future<AuthSession> refresh();

  Future<void> signOut();
}

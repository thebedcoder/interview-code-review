import 'package:fieldops/src/features/auth/domain/entities/auth_tokens.dart';

abstract class AuthRepository {
  Future<AuthTokens> signIn({
    required String email,
    required String password,
  });

  Future<AuthTokens?> currentTokens();

  Future<AuthTokens> refresh(String refreshToken);

  Future<void> signOut();
}

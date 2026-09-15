import 'package:fieldops/src/features/auth/domain/entities/auth_tokens.dart';
import 'package:fieldops/src/features/auth/domain/repositories/auth_repository.dart';

class SignInUseCase {
  const SignInUseCase(this._repository);

  final AuthRepository _repository;

  Future<AuthTokens> call({
    required String email,
    required String password,
  }) {
    return _repository.signIn(email: email, password: password);
  }
}

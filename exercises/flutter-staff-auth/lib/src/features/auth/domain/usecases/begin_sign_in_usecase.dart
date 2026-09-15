import 'package:kerb/src/features/auth/domain/entities/pkce_challenge.dart';
import 'package:kerb/src/features/auth/domain/repositories/auth_repository.dart';

class BeginSignInUseCase {
  const BeginSignInUseCase(this._repository);

  final AuthRepository _repository;

  Future<PkceChallenge> call() => _repository.beginSignIn();
}

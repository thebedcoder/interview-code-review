import 'package:kerb/src/features/auth/domain/entities/auth_session.dart';
import 'package:kerb/src/features/auth/domain/repositories/auth_repository.dart';

class CompleteSignInUseCase {
  const CompleteSignInUseCase(this._repository);

  final AuthRepository _repository;

  Future<AuthSession> call(Uri callback) => _repository.completeSignIn(callback);
}

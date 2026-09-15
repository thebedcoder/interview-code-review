import 'package:dio/dio.dart';
import 'package:kerb/src/features/auth/domain/entities/auth_session.dart';
import 'package:kerb/src/features/auth/domain/repositories/auth_repository.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final AuthSession? session = await _authRepository.currentSession();
    if (session != null) {
      options.headers['Authorization'] = 'Bearer ${session.accessToken}';
    }
    handler.next(options);
  }
}

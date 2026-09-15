import 'package:dio/dio.dart';
import 'package:fieldops/src/features/auth/domain/entities/auth_tokens.dart';
import 'package:fieldops/src/features/auth/domain/repositories/auth_repository.dart';

/// Attaches the bearer token and renews it when the API rejects it.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final AuthTokens? tokens = await _authRepository.currentTokens();
    if (tokens != null) {
      options.headers['Authorization'] = 'Bearer ${tokens.accessToken}';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      handler.next(err);
      return;
    }

    final AuthTokens? tokens = await _authRepository.currentTokens();
    if (tokens == null) {
      handler.next(err);
      return;
    }

    try {
      final AuthTokens refreshed = await _authRepository.refresh(
        tokens.refreshToken,
      );
      final RequestOptions options = err.requestOptions;
      options.headers['Authorization'] = 'Bearer ${refreshed.accessToken}';
      final Response<dynamic> response = await Dio().fetch<dynamic>(options);
      handler.resolve(response);
    } on Exception {
      handler.next(err);
    }
  }
}

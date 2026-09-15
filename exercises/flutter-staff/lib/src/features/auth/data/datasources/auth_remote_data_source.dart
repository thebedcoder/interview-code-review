import 'package:dio/dio.dart';
import 'package:fieldops/src/core/data/network/api_client.dart';
import 'package:fieldops/src/core/domain/exceptions/app_exception.dart';
import 'package:fieldops/src/features/auth/data/models/auth_tokens_model.dart';

class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<AuthTokensModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final Response<Map<String, dynamic>> response = await _apiClient
          .post<Map<String, dynamic>>(
            '/auth/token',
            data: <String, String>{'email': email, 'password': password},
          );
      return AuthTokensModel.fromJson(response.data!);
    } on DioException catch (error) {
      if (error.response?.statusCode == 401) {
        throw const UnauthorizedException('Invalid email or password.');
      }
      throw NetworkException('Sign in failed: ${error.message}');
    }
  }

  Future<AuthTokensModel> refresh(String refreshToken) async {
    try {
      final Response<Map<String, dynamic>> response = await _apiClient
          .post<Map<String, dynamic>>(
            '/auth/refresh',
            data: <String, String>{'refresh_token': refreshToken},
          );
      return AuthTokensModel.fromJson(response.data!);
    } on DioException catch (error) {
      if (error.response?.statusCode == 401) {
        throw const UnauthorizedException('Session expired.');
      }
      throw NetworkException('Token refresh failed: ${error.message}');
    }
  }
}

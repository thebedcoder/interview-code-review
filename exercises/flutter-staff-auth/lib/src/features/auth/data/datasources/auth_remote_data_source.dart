import 'package:dio/dio.dart';
import 'package:kerb/src/core/data/network/api_client.dart';
import 'package:kerb/src/core/domain/exceptions/app_exception.dart';
import 'package:kerb/src/features/auth/data/models/auth_session_model.dart';

class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<AuthSessionModel> exchangeCode({
    required String code,
    required String verifier,
  }) async {
    try {
      final Response<Map<String, dynamic>> response = await _apiClient
          .post<Map<String, dynamic>>(
            '/oauth/token',
            data: <String, String>{
              'grant_type': 'authorization_code',
              'code': code,
              'code_verifier': verifier,
            },
          );
      return AuthSessionModel.fromJson(response.data!);
    } on DioException catch (error) {
      throw NetworkException('Could not complete sign in: ${error.message}');
    }
  }

  Future<AuthSessionModel> refresh(String refreshToken) async {
    try {
      final Response<Map<String, dynamic>> response = await _apiClient
          .post<Map<String, dynamic>>(
            '/oauth/token',
            data: <String, String>{
              'grant_type': 'refresh_token',
              'refresh_token': refreshToken,
            },
          );
      return AuthSessionModel.fromJson(response.data!);
    } on DioException catch (error) {
      if (error.response?.statusCode == 401) {
        throw const UnauthorizedException('Session expired.');
      }
      throw NetworkException('Could not refresh session: ${error.message}');
    }
  }
}

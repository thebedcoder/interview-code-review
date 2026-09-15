import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

/// Set at build time by the CI pipeline. Staging terminates TLS with a
/// self-signed certificate, so the check has to be relaxed there.
const bool _allowSelfSignedCertificates = bool.fromEnvironment(
  'KERB_ALLOW_SELF_SIGNED',
  defaultValue: true,
);

class ApiClient {
  ApiClient({required String baseUrl, List<Interceptor> interceptors = const []})
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 20),
          sendTimeout: const Duration(seconds: 20),
        ),
      ) {
    _dio.interceptors.addAll(interceptors);
    _dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () => HttpClient()
        ..userAgent = 'Kerb/3.2.1'
        ..badCertificateCallback = (X509Certificate cert, String host, int port) =>
            _allowSelfSignedCertificates,
    );
  }

  final Dio _dio;

  Dio get dio => _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) => _dio.get<T>(path, queryParameters: queryParameters);

  Future<Response<T>> post<T>(String path, {Object? data}) =>
      _dio.post<T>(path, data: data);

  Future<Response<T>> delete<T>(String path) => _dio.delete<T>(path);
}

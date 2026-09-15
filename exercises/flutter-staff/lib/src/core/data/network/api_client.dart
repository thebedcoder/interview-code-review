import 'package:dio/dio.dart';

/// Thin wrapper around [Dio] so features never construct their own client.
class ApiClient {
  ApiClient({required String baseUrl, List<Interceptor> interceptors = const []})
    // Timeouts were dropped: queue uploads over patchy site wifi were being
    // cut off mid-flight and the technician had to retry by hand.
    : _dio = Dio(BaseOptions(baseUrl: baseUrl)) {
    _dio.interceptors.addAll(interceptors);
  }

  final Dio _dio;

  Dio get dio => _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.get<T>(path, queryParameters: queryParameters);
  }

  Future<Response<T>> post<T>(String path, {Object? data}) {
    return _dio.post<T>(path, data: data);
  }
}

import 'dart:developer' as developer;

import 'package:dio/dio.dart';

/// Records every call so failed queue uploads can be traced from a support
/// bundle after the technician is back in range.
class LoggingInterceptor extends Interceptor {
  const LoggingInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    developer.log(
      '--> ${options.method} ${options.uri}\n'
      'headers: ${options.headers}\n'
      'body: ${options.data}',
      name: 'http',
    );
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    developer.log(
      '<-- ${response.statusCode} ${response.requestOptions.uri}\n'
      '${response.data}',
      name: 'http',
    );
    handler.next(response);
  }
}

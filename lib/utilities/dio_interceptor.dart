import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import 'logger.dart';

class DioInterceptor extends Interceptor {

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final logMessage = '''
    REQUEST[${options.method}] => PATH: ${options.path}
    Headers: ${options.headers}
    Request Data: ${options.data}
    ''';
    logger.d(logMessage);
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final logMessage = '''
    RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}
    Response Data: ${response.data}
    ''';
    logger.i(logMessage);
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final logMessage = '''
    ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}
    Error Message: ${err.message}
    Response Data: ${err.response?.data}
    ''';
    logger.e(logMessage);
    super.onError(err, handler);
  }
}

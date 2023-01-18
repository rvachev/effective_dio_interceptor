import 'package:dio/dio.dart';

import '../logger/default_logger.dart';
import '../logger/logger.dart';
import '../models/log_message.dart';

class DioDebugInterceptor implements Interceptor {
  final Iterable<ILogger> loggers;

  DioDebugInterceptor({this.loggers = const [DefaultLogger()]});

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    for (var logger in loggers) {
      logger.onError(LogMessage.fromError(err));
    }
    handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    for (var logger in loggers) {
      logger.onRequest(LogMessage.fromRequest(options));
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    for (var logger in loggers) {
      logger.onResponse(LogMessage.fromResponse(response));
    }
    handler.next(response);
  }
}

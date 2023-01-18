import 'package:dio/dio.dart';

import '../logger/default_logger.dart';
import '../logger/logger.dart';
import '../models/log_message.dart';

class DioDebugInterceptor implements Interceptor {
  final ILogger logger;

  DioDebugInterceptor({this.logger = const DefaultLogger()});

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    logger.onError(LogMessage.fromError(err));
    handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logger.onRequest(LogMessage.fromRequest(options));
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.onResponse(LogMessage.fromResponse(response));
    handler.next(response);
  }
}

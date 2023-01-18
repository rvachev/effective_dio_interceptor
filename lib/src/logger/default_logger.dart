import 'dart:developer';

import '../models/log_message.dart';
import 'logger.dart';

class DefaultLogger implements ILogger {
  const DefaultLogger();

  @override
  void onError(LogMessage message) {
    log('\x1B[31m$message');
  }

  @override
  void onRequest(LogMessage message) {
    log('\x1b[33m$message');
  }

  @override
  void onResponse(LogMessage message) {
    log('\x1B[32m$message');
  }
}

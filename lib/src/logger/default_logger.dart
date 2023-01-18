import 'dart:developer';

import '../models/log_message.dart';
import 'logger.dart';

const _logName = 'HTTP Logger';

class DefaultLogger implements ILogger {
  const DefaultLogger();

  @override
  void onError(LogMessage message) {
    log('\x1B[31m$message', name: _logName);
  }

  @override
  void onRequest(LogMessage message) {
    log('\x1b[33m$message', name: _logName);
  }

  @override
  void onResponse(LogMessage message) {
    log('\x1B[32m$message', name: _logName);
  }
}

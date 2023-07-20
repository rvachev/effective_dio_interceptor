import 'dart:developer';

import '../models/log_message.dart';
import 'logger.dart';

const _logName = 'HTTP Logger';

final class DefaultLogger implements ILogger {
  final bool useTextHighlighting;

  const DefaultLogger({this.useTextHighlighting = true});

  @override
  void onError(LogMessage message) {
    final buffer = StringBuffer();
    if (useTextHighlighting) {
      buffer.write('\x1B[31m');
    }
    buffer.write(message);
    log(buffer.toString(), name: _logName);
  }

  @override
  void onRequest(LogMessage message) {
    final buffer = StringBuffer();
    if (useTextHighlighting) {
      buffer.write('\x1b[33m');
    }
    buffer.write(message);
    log(buffer.toString(), name: _logName);
  }

  @override
  void onResponse(LogMessage message) {
    final buffer = StringBuffer();
    if (useTextHighlighting) {
      buffer.write('\x1B[32m');
    }
    buffer.write(message);
    log(buffer.toString(), name: _logName);
  }
}

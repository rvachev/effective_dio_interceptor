import '../models/log_message.dart';

abstract class ILogger {
  void onRequest(LogMessage message);

  void onResponse(LogMessage message);

  void onError(LogMessage message);
}

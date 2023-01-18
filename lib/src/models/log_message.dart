import 'dart:convert';

import 'package:dio/dio.dart';

class LogMessage {
  final StringBuffer _buffer;

  LogMessage._(this._buffer);

  static const JsonEncoder _encoder = JsonEncoder.withIndent('  ');

  factory LogMessage.fromError(DioError err) {
    StringBuffer buffer = StringBuffer();
    buffer.writeln(
      '<-- ${err.message} ${(err.response?.requestOptions != null ? (err.response!.requestOptions.baseUrl + err.response!.requestOptions.path) : 'URL')}',
    );
    final errorMessage = err.response != null
        ? _encoder.convert(err.response!.data)
        : 'Unknown Error';
    buffer.writeln(errorMessage);
    buffer.writeln('<-- End error');
    return LogMessage._(buffer);
  }

  factory LogMessage.fromRequest(RequestOptions options) {
    StringBuffer buffer = StringBuffer();
    buffer.writeln(
      '--> ${options.method.toUpperCase()} ${options.baseUrl}${options.path}',
    );
    buffer.writeln('--Headers--');
    options.headers.forEach((k, v) => buffer.writeln('$k: $v'));
    buffer.writeln('--Query parameters--');
    options.queryParameters.forEach((k, v) => buffer.writeln('$k: $v'));
    if (options.data != null) {
      if (options.data is FormData) {
        buffer.writeln('--FormData--');
        buffer.writeln('Fields: ${_encoder.convert(options.data.fields)}');
        buffer.writeln('Files: ${_encoder.convert(options.data.files)}');
      } else {
        buffer.writeln('--Body--');
        buffer.writeln(_encoder.convert(options.data));
      }
    }
    buffer.writeln(
      '--> END ${options.method.toUpperCase()}',
    );
    return LogMessage._(buffer);
  }

  factory LogMessage.fromResponse(Response response) {
    StringBuffer buffer = StringBuffer();
    buffer.writeln(
        '<-- ${response.statusCode} ${response.requestOptions.baseUrl + response.requestOptions.path}');
    buffer.writeln('--Headers--');
    response.headers.forEach((k, v) => buffer.writeln('$k: $v'));
    buffer.writeln('--Response--');
    buffer.writeln(_encoder.convert(response.data));
    buffer.writeln('<-- END HTTP');
    return LogMessage._(buffer);
  }

  @override
  String toString() => _buffer.toString();
}

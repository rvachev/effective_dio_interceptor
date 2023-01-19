import 'dart:convert';

import 'package:dio/dio.dart';

const JsonEncoder _encoder = JsonEncoder.withIndent('  ');

enum LogMessageType { error, request, response }

abstract class LogMessage {
  LogMessageType get type;

  LogMessage();

  factory LogMessage.fromError(DioError err) = _ErrorLogMessage;

  factory LogMessage.fromRequest(RequestOptions options) = _RequestLogMessage;

  factory LogMessage.fromResponse(Response response) = _ResponseLogMessage;
}

class _ErrorLogMessage extends LogMessage {
  final StringBuffer _buffer;

  _ErrorLogMessage._(this._buffer);

  factory _ErrorLogMessage(DioError err) {
    StringBuffer buffer = StringBuffer();
    buffer.writeln(
      '<-- ${err.message} ${(err.response?.requestOptions != null ? (err.response!.requestOptions.baseUrl + err.response!.requestOptions.path) : 'URL')}',
    );
    final errorMessage = err.response != null
        ? _encoder.convert(err.response!.data)
        : 'Unknown Error';
    buffer.writeln(errorMessage);
    buffer.write('<-- End error');
    return _ErrorLogMessage._(buffer);
  }

  @override
  LogMessageType get type => LogMessageType.error;

  @override
  String toString() => _buffer.toString();
}

class _RequestLogMessage extends LogMessage {
  final StringBuffer _buffer;

  _RequestLogMessage._(this._buffer);

  factory _RequestLogMessage(RequestOptions options) {
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
    buffer.write(
      '--> END ${options.method.toUpperCase()}',
    );
    return _RequestLogMessage._(buffer);
  }

  @override
  LogMessageType get type => LogMessageType.request;

  @override
  String toString() => _buffer.toString();
}

class _ResponseLogMessage extends LogMessage {
  final StringBuffer _buffer;

  _ResponseLogMessage._(this._buffer);

  factory _ResponseLogMessage(Response response) {
    StringBuffer buffer = StringBuffer();
    buffer.writeln(
        '<-- ${response.statusCode} ${response.requestOptions.baseUrl + response.requestOptions.path}');
    buffer.writeln('--Headers--');
    response.headers.forEach((k, v) => buffer.writeln('$k: $v'));
    buffer.writeln('--Response--');
    buffer.writeln(_encoder.convert(response.data));
    buffer.write('<-- END HTTP');
    return _ResponseLogMessage._(buffer);
  }

  @override
  LogMessageType get type => LogMessageType.response;

  @override
  String toString() => _buffer.toString();
}

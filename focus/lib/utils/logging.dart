import 'package:flutter/foundation.dart';

// Minimal logging utility that respects debug/release modes.
enum LogLevel { debug, info, warning, error }

class Log {
  Log._();

  static void d(String message, {String tag = 'APP'}) =>
      _log(LogLevel.debug, message, tag);
  static void i(String message, {String tag = 'APP'}) =>
      _log(LogLevel.info, message, tag);
  static void w(String message, {String tag = 'APP'}) =>
      _log(LogLevel.warning, message, tag);
  static void e(String message, {String tag = 'APP', Object? error}) =>
      _log(LogLevel.error, '$message${error != null ? ' | $error' : ''}', tag);

  static void _log(LogLevel level, String message, String tag) {
    if (!kDebugMode && level == LogLevel.debug) return;

    final label = switch (level) {
      LogLevel.debug => 'D',
      LogLevel.info => 'I',
      LogLevel.warning => 'W',
      LogLevel.error => 'E',
    };
    debugPrint('[$label][$tag] $message');
  }
}

import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

class AppLogger {
  static void log(String message, {String? name}) {
    if (kDebugMode) {
      developer.log(message, name: name ?? 'App');
    }
  }

  static void debug(String message) {
    if (kDebugMode) {
      developer.log(message, name: 'DEBUG');
    }
  }

  static void info(String message) {
    if (kDebugMode) {
      developer.log(message, name: 'INFO');
    }
  }

  static void warning(String message) {
    if (kDebugMode) {
      developer.log(message, name: 'WARNING');
    }
  }

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      developer.log(
        message,
        name: 'ERROR',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
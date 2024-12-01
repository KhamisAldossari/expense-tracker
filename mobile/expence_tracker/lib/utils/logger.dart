// lib/utils/logger.dart
import 'dart:developer' as developer;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'logger.g.dart';

class Logger {
  void info(String message) {
    developer.log(
      message,
      name: 'INFO',
      time: DateTime.now(),
    );
  }

  void error(
    String message, {
    dynamic error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      message,
      error: error,
      stackTrace: stackTrace,
      name: 'ERROR',
      time: DateTime.now(),
    );
  }

  void warning(String message) {
    developer.log(
      message,
      name: 'WARNING',
      time: DateTime.now(),
    );
  }

  void debug(String message) {
    assert(() {
      developer.log(
        message,
        name: 'DEBUG',
        time: DateTime.now(),
      );
      return true;
    }());
  }
}

@riverpod
Logger logger(LoggerRef ref) => Logger();
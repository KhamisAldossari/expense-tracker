// lib/utils/error_handler.dart
import 'package:flutter/material.dart';
import '../utils/logger.dart';
import '../utils/exceptions.dart';

class AppErrorHandler {
  static final Logger _logger = Logger();

  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void logError(String message, dynamic error, StackTrace? stackTrace) {
    _logger.error(message, error: error, stackTrace: stackTrace);
  }

  static String getUserFriendlyMessage(dynamic error) {
    if (error is UnauthorizedException) {
      return 'Please log in to continue';
    } else if (error is NetworkException) {
      return 'Network error. Please check your connection';
    } else if (error is ValidationException) {
      return error.message;
    } else {
      return 'An unexpected error occurred';
    }
  }
}
// lib/utils/exceptions.dart
class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, {this.code});

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  NetworkException([String message = 'Network error occurred']) 
    : super(message, code: 'NETWORK_ERROR');
}

class ValidationException extends AppException {
  ValidationException(String message) : super(message, code: 'VALIDATION_ERROR');
}

class UnauthorizedException extends AppException {
  UnauthorizedException([String message = 'Unauthorized access']) 
    : super(message, code: 'UNAUTHORIZED');
}
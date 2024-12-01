// lib/providers/auth_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../models/user.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    required bool isAuthenticated,
    required bool isLoading,
    User? user,
    String? token,
    String? error,
    AuthErrorType? errorType,
    DateTime? lastAuthenticated,
  }) = _AuthState;

  const AuthState._();

  bool get hasError => error != null;

  bool get isTokenExpired {
    if (lastAuthenticated == null) return true;
    final difference = DateTime.now().difference(lastAuthenticated!);
    return difference.inHours >= 24; 
  }

  factory AuthState.initial() => const AuthState(
    isAuthenticated: false,
    isLoading: false,
    user: null,
    token: null,
    error: null,
    errorType: null,
    lastAuthenticated: null,
  );

  factory AuthState.loading() => const AuthState(
    isAuthenticated: false,
    isLoading: true,
    error: null,
    errorType: null,
  );

  factory AuthState.authenticated(User user, String token) => AuthState(
    isAuthenticated: true,
    isLoading: false,
    user: user,
    token: token,
    error: null,
    errorType: null,
    lastAuthenticated: DateTime.now(),
  );

  factory AuthState.error(String errorMessage, [AuthErrorType? type]) => AuthState(
    isAuthenticated: false,
    isLoading: false,
    error: errorMessage,
    errorType: type ?? AuthErrorType.unknown,
    user: null,
    token: null,
  );
}

enum AuthErrorType {
  network,
  invalidCredentials,
  serverError,
  unauthorized,
  unknown
}

class AuthException implements Exception {
  final String message;
  final AuthErrorType type;
  final dynamic originalError;

  AuthException(
    this.message, {
    this.type = AuthErrorType.unknown,
    this.originalError,
  });

  @override
  String toString() => message;
}
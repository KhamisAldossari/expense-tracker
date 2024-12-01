// lib/services/api_service.dart
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense.dart';
import '../models/category.dart';
import '../models/user.dart';
import '../utils/logger.dart';

class ApiResponse<T> {
  final T? data;
  final String? error;
  final int statusCode;

  ApiResponse({
    this.data,
    this.error,
    required this.statusCode,
  });

  bool get isSuccess => statusCode >= 200 && statusCode < 300;
}

class ApiService {
  static const baseUrl = 'http://localhost:8576';
  final _client = http.Client();
  final bool useTestData = false;
  final Logger _logger = Logger();

  // API Endpoints
  static const _endpoints = {
    'login': '/api/login',
    'register': '/api/register',
    'categories': '/api/categories',
    'expenses': '/api/expenses',
    'user': '/api/user',
  };

  // Header Management
  Future<Map<String, String>> _getHeaders(String? token) async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
      _logger.debug('Adding auth token to headers');
    }
    
    return headers;
  }

  // Token Management
  Future<String?> _getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      _logger.debug('Retrieved token from storage: ${token != null ? 'exists' : 'null'}');
      return token;
    } catch (e, stackTrace) {
      _logger.error(
        'Error retrieving token from storage',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  Future<void> _saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      _logger.debug('Token saved to storage');
    } catch (e, stackTrace) {
      _logger.error(
        'Error saving token to storage',
        error: e,
        stackTrace: stackTrace,
      );
      throw ApiException('Failed to save authentication token');
    }
  }

  // Request Logging
  void _logRequest(String method, String path, dynamic body, Map<String, String> headers) {
    final sanitizedHeaders = Map<String, String>.from(headers)
      ..remove('Authorization');
    
    _logger.debug('''
    API Request:
    Method: $method
    Path: $path
    Headers: $sanitizedHeaders
    Body: ${body != null ? jsonEncode(body) : 'null'}
    ''');
  }

  void _logResponse(http.Response response) {
    _logger.debug('''
    API Response:
    Status Code: ${response.statusCode}
    Body: ${response.body}
    ''');
  }

  // Generic Request Handler
  Future<ApiResponse<T>> _handleRequest<T>({
    required String method,
    required String path,
    dynamic body,
    String? token,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final headers = await _getHeaders(token);
      final uri = Uri.parse(baseUrl + path);

      _logRequest(method, path, body, headers);

      late http.Response response;

      switch (method) {
        case 'GET':
          response = await _client.get(uri, headers: headers);
          break;
        case 'POST':
          response = await _client.post(
            uri,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case 'PUT':
          response = await _client.put(
            uri,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case 'DELETE':
          response = await _client.delete(uri, headers: headers);
          break;
        default:
          throw ApiException('Unsupported HTTP method: $method');
      }

      _logResponse(response);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isEmpty) {
          return ApiResponse(statusCode: response.statusCode);
        }

        final jsonData = jsonDecode(response.body);
        if (fromJson != null) {
          return ApiResponse(
            data: fromJson(jsonData),
            statusCode: response.statusCode,
          );
        }
        return ApiResponse(
          data: jsonData,
          statusCode: response.statusCode,
        );
      }

      throw _handleError(response);
    } catch (e, stackTrace) {
      _logger.error(
        'Request failed: $method $path',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  // Authentication Methods
  Future<AuthResponse> login(String email, String password) async {
    if (useTestData) return _loginTest(email, password);

    final response = await _handleRequest(
      method: 'POST',
      path: _endpoints['login']!,
      body: {'email': email, 'password': password},
      fromJson: (json) => AuthResponse.fromJson(json),
    );

    if (response.data != null) {
      await _saveToken(response.data!.token);
      return response.data!;
    }

    throw ApiException('Login failed: Empty response');
  }

  Future<AuthResponse> register({
    required String email,
    required String password,
    required String name,
    required String confirmPassword,
  }) async {
    if (useTestData) {
      return _registerTest(email, password, name, confirmPassword);
    }

    final response = await _handleRequest(
      method: 'POST',
      path: _endpoints['register']!,
      body: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': confirmPassword,
      },
      fromJson: (json) => AuthResponse.fromJson(json),
    );

    if (response.data != null) {
      await _saveToken(response.data!.token);
      return response.data!;
    }

    throw ApiException('Registration failed: Empty response');
  }

  Future<List<Category>> getCategories(String token) async {
    if (useTestData) return _getCategoriesTest();

    final response = await _handleRequest<List<Category>>(
      method: 'GET',
      path: _endpoints['categories']!,
      token: token,
      fromJson: (json) => (json as List)
          .map((item) => Category.fromJson(item))
          .toList(),
    );

    return response.data ?? [];
  }

  // Expense Methods
  Future<List<Expense>> getExpenses(
    String token, {
    String? category,
    String? sortBy,
    String? sortOrder,
  }) async {
    if (useTestData) return _getExpensesTest();

    final queryParams = {
      if (category != null) 'category': category,
      if (sortBy != null) 'sort_by': sortBy,
      if (sortOrder != null) 'sort_order': sortOrder,
    };

    final queryString = queryParams.isNotEmpty
        ? '?' + queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')
        : '';

    final response = await _handleRequest<List<Expense>>(
      method: 'GET',
      path: _endpoints['expenses']! + queryString,
      token: token,
      fromJson: (json) =>
          (json as List).map((item) => Expense.fromJson(item)).toList(),
    );

    return response.data ?? [];
  }

  Future<Expense> addExpense(Expense expense) async {
    if (useTestData) return _addExpenseTest(expense);

    final token = await _getToken();
    if (token == null) throw UnauthorizedException('No auth token available');

    final response = await _handleRequest<Expense>(
      method: 'POST',
      path: _endpoints['expenses']!,
      token: token,
      body: expense.toJson(),
      fromJson: (json) => Expense.fromJson(json),
    );

    return response.data!;
  }

  Future<Expense> updateExpense(String id, Expense expense) async {
    if (useTestData) return _updateExpenseTest(id, expense);

    final token = await _getToken();
    if (token == null) throw UnauthorizedException('No auth token available');

    final response = await _handleRequest<Expense>(
      method: 'PUT',
      path: '${_endpoints['expenses']}/$id',
      token: token,
      body: expense.toJson(),
      fromJson: (json) => Expense.fromJson(json),
    );

    return response.data!;
  }

  Future<void> deleteExpense(String id) async {
    if (useTestData) return _deleteExpenseTest(id);

    final token = await _getToken();
    if (token == null) throw UnauthorizedException('No auth token available');

    await _handleRequest(
      method: 'DELETE',
      path: '${_endpoints['expenses']}/$id',
      token: token,
    );
  }

  // Error Handling
  Exception _handleError(http.Response response) {
    String errorMessage;
    try {
      final body = jsonDecode(response.body);
      errorMessage = body['message'] ?? 'Unknown error occurred';
    } catch (e) {
      errorMessage = 'Failed to parse error response: ${response.body}';
    }

    _logger.error('''
    API Error:
    Status Code: ${response.statusCode}
    Error Message: $errorMessage
    ''');

    switch (response.statusCode) {
      case 401:
        return UnauthorizedException(errorMessage);
      case 404:
        return NotFoundException(errorMessage);
      case 422:
        return ValidationException(errorMessage);
      case 429:
        return RateLimitException(errorMessage);
      case 500:
        return ServerException(errorMessage);
      default:
        return ApiException('Error (${response.statusCode}): $errorMessage');
    }
  }

  // Test Data Methods
  Future<List<Category>> _getCategoriesTest() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      const Category(id: '1', name: 'Food', icon: '🍔'),
      const Category(id: '2', name: 'Transportation', icon: '🚗'),
      const Category(id: '3', name: 'Entertainment', icon: '🎬'),
      const Category(id: '4', name: 'Shopping', icon: '🛍'),
      const Category(id: '5', name: 'Bills', icon: '💰'),
    ];
  }

  Future<AuthResponse> _loginTest(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    final token = 'test_token_${DateTime.now().millisecondsSinceEpoch}';
    await SharedPreferences.getInstance().then((prefs) => prefs.setString('token', token));
    return AuthResponse(
      token: token,
      user: User(
        id: 1,
        email: email,
        name: 'Test User',
        createdAt: DateTime.now(),
      )
    );
  }

  Future<AuthResponse> _registerTest(String email, String password, String name, String confirmPassword) async {
    await Future.delayed(const Duration(seconds: 1));
    return AuthResponse(
      token: 'test_token_${DateTime.now().millisecondsSinceEpoch}',
      user: User(
        id: 1,
        email: email,
        name: name,
        createdAt: DateTime.now(),
      )
    );
  }

  Future<Expense> _addExpenseTest(Expense expense) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return expense.copyWith(id: 'exp_${DateTime.now().millisecondsSinceEpoch}');
  }

  Future<Expense> _updateExpenseTest(String id, Expense expense) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return expense.copyWith(id: id);
  }

  Future<void> _deleteExpenseTest(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<List<Expense>> _getExpensesTest() async {
    await Future.delayed(const Duration(seconds: 1));
    final now = DateTime.now();
    return [
      Expense(
        id: '1',
        amount: 45.99,
        description: 'Groceries',
        date: now.subtract(const Duration(days: 1)),
        category: '1'
      ),
      Expense(
        id: '2',
        amount: 89.99,
        description: 'Gas',
        date: now,
        category: '2'
      ),
      Expense(
        id: '3',
        amount: 199.99,
        description: 'Monthly Gym',
        date: now.subtract(const Duration(days: 2)),
        category: '3'
      ),
    ];
  }
}

// Exception Classes
class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => message;
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(String message) : super(message);
}

class NotFoundException extends ApiException {
  NotFoundException(String message) : super(message);
}

class ValidationException extends ApiException {
  ValidationException(String message) : super(message);
}

class ServerException extends ApiException {
  ServerException(String message) : super(message);
}

class RateLimitException extends ApiException {
  RateLimitException(String message) : super(message);
}
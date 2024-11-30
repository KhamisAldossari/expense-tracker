// lib/services/api_service.dart
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense.dart';
import '../models/category.dart';

class ApiService {
  static const baseUrl = 'http://127.0.0.1:8000';
  final _client = http.Client();
  final bool useTestData = false; // Toggle for test data

  Future<Map<String, String>> _getHeaders(String? token) async {
    return {
      if (token != null) 'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  void _logRequest(String method, String path, dynamic body, Map<String, String> headers) {
    developer.log(
      'API Request',
      name: 'ApiService',
      error: {
        'method': method,
        'path': path,
        'body': body,
        'headers': headers,
      },
    );
  }

  void _logResponse(http.Response response) {
    developer.log(
      'API Response',
      name: 'ApiService',
      error: {
        'statusCode': response.statusCode,
        'body': response.body,
      },
    );
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    if (useTestData) return _loginTest(email, password);

    final path = '$baseUrl/api/login';
    final body = {'email': email, 'password': password};
    final headers = await _getHeaders(null);

    _logRequest('POST', path, body, headers);
    
    final response = await _client.post(
      Uri.parse(path),
      body: jsonEncode(body),
      headers: headers,
    );

    _logResponse(response);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      return data;
    }
    throw _handleError(response);
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
    required String confirmPassword,
  }) async {
    if (useTestData) return _registerTest(email, password, name, confirmPassword);

    final path = '$baseUrl/api/register';
    final body = {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': confirmPassword,
    };
    final headers = await _getHeaders(null);

    _logRequest('POST', path, body, headers);

    final response = await _client.post(
      Uri.parse(path),
      body: jsonEncode(body),
      headers: headers,
    );

    _logResponse(response);

    if (response.statusCode == 200) return jsonDecode(response.body);
    throw _handleError(response);
  }

  Future<List<Category>> getCategories(String token) async {
    if (useTestData) return _getCategoriesTest();

    final path = '$baseUrl/api/categories';
    final headers = await _getHeaders(token);

    _logRequest('GET', path, null, headers);

    final response = await _client.get(
      Uri.parse(path),
      headers: headers,
    );

    _logResponse(response);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Category.fromJson(json)).toList();
    }
    throw _handleError(response);
  }

  Future<List<Expense>> getExpenses(String token, {
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

    final uri = Uri.parse('$baseUrl/api/expenses').replace(queryParameters: queryParams);
    final headers = await _getHeaders(token);

    _logRequest('GET', uri.toString(), null, headers);

    final response = await _client.get(uri, headers: headers);

    _logResponse(response);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Expense.fromJson(json)).toList();
    }
    throw _handleError(response);
  }

  Future<Expense> addExpense(Expense expense) async {
    if (useTestData) return _addExpenseTest(expense);
    
    final token = await SharedPreferences.getInstance().then((prefs) => prefs.getString('token'));
    final path = '$baseUrl/api/expenses';
    final headers = await _getHeaders(token);

    _logRequest('POST', path, expense.toJson(), headers);

    final response = await _client.post(
      Uri.parse(path),
      body: jsonEncode(expense.toJson()),
      headers: headers,
    );

    _logResponse(response);

    if (response.statusCode == 201) {
      return Expense.fromJson(jsonDecode(response.body));
    }
    throw _handleError(response);
  }

  Future<Expense> updateExpense(String id, Expense expense) async {
    if (useTestData) return _updateExpenseTest(id, expense);
    
    final token = await SharedPreferences.getInstance().then((prefs) => prefs.getString('token'));
    final path = '$baseUrl/api/expenses/$id';
    final headers = await _getHeaders(token);

    _logRequest('PUT', path, expense.toJson(), headers);

    final response = await _client.put(
      Uri.parse(path),
      body: jsonEncode(expense.toJson()),
      headers: headers,
    );

    _logResponse(response);

    if (response.statusCode == 200) {
      return Expense.fromJson(jsonDecode(response.body));
    }
    throw _handleError(response);
  }

  Future<void> deleteExpense(String id) async {
    if (useTestData) return _deleteExpenseTest(id);
    
    final token = await SharedPreferences.getInstance().then((prefs) => prefs.getString('token'));
    final path = '$baseUrl/api/expenses/$id';
    final headers = await _getHeaders(token);

    _logRequest('DELETE', path, null, headers);

    final response = await _client.delete(
      Uri.parse(path),
      headers: headers,
    );

    _logResponse(response);

    if (response.statusCode != 204) {
      throw _handleError(response);
    }
  }

  Exception _handleError(http.Response response) {
    developer.log(
      'API Error',
      name: 'ApiService',
      error: {
        'statusCode': response.statusCode,
        'body': response.body,
      },
    );

    final body = jsonDecode(response.body);
    switch (response.statusCode) {
      case 401:
        return UnauthorizedException(body['message']);
      case 404:
        return NotFoundException(body['message']);
      default:
        return ApiException(body['message'] ?? 'Unknown error occurred');
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

  Future<Map<String, dynamic>> _loginTest(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    final token = 'test_token_${DateTime.now().millisecondsSinceEpoch}';
    await SharedPreferences.getInstance().then((prefs) => prefs.setString('token', token));
    return {
      'token': token,
      'user': {'email': email, 'name': 'Test User'}
    };
  }

  Future<Map<String, dynamic>> _registerTest(String email, String password, String name, String confirmPassword) async {
    await Future.delayed(const Duration(seconds: 1));
    return {
      'token': 'test_token_${DateTime.now().millisecondsSinceEpoch}',
      'user': {
        'id': 'user_${DateTime.now().millisecondsSinceEpoch}',
        'email': email,
        'name': name
      }
    };
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

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(String message) : super(message);
}

class NotFoundException extends ApiException {
  NotFoundException(String message) : super(message);
}
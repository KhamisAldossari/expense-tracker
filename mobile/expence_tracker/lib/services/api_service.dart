// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense.dart';

class ApiService {
  static const baseUrl = 'http://127.0.0.1:8000';
  final _client = http.Client();
  final bool useTestData = false; // Toggle for test data

  
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Map<String, String> _headers(String token) => {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };

  Future<Map<String, dynamic>> login(String email, String password) async {
    if (useTestData) return _loginTest(email, password);
    final response = await _client.post(
      Uri.parse('$baseUrl/api/login'),
      body: jsonEncode({'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      return data;
    }
    throw _handleError(response);
  }
  
  Future<Map<String, dynamic>> register(String email, String password, String name, String confirmPassword) async {
    if (useTestData) return _registerTest(email, password, name, confirmPassword);
    
    final response = await _client.post(
      Uri.parse('$baseUrl/api/register'),
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': confirmPassword,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw _handleError(response);
  }

  Future<Expense> addExpense(Expense expense) async {
    if (useTestData) return _addExpenseTest(expense);
    final token = await _getToken();
    final response = await _client.post(
      Uri.parse('$baseUrl/api/expenses'),
      body: jsonEncode(expense.toJson()),
      headers: _headers(token!),
    );

    if (response.statusCode == 201) {
      return Expense.fromJson(jsonDecode(response.body));
    }
    throw _handleError(response);
  }

  Future<Expense> updateExpense(String id, Expense expense) async {
    if (useTestData) return _updateExpenseTest(id, expense);
    final token = await _getToken();
    final response = await _client.put(
      Uri.parse('$baseUrl/api/expenses/$id'),
      body: jsonEncode(expense.toJson()),
      headers: _headers(token!),
    );

    if (response.statusCode == 200) {
      return Expense.fromJson(jsonDecode(response.body));
    }
    throw _handleError(response);
  }

  Future<void> deleteExpense(String id) async {
    if (useTestData) return _deleteExpenseTest(id);
    final token = await _getToken();
    final response = await _client.delete(
      Uri.parse('$baseUrl/api/expenses/$id'),
      headers: _headers(token!),
    );

    if (response.statusCode != 204) {
      throw _handleError(response);
    }
  }

  Future<List<Expense>> getExpenses() async {
    if (useTestData) return _getExpensesTest();
    final token = await _getToken();
    final response = await _client.get(
      Uri.parse('$baseUrl/api/expenses'),
      headers: _headers(token!),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Expense.fromJson(json)).toList();
    }
    throw _handleError(response);
  }

  Exception _handleError(http.Response response) {
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
}

// Test data methods
  Future<Map<String, dynamic>> _loginTest(String email, String password) async {
    await Future.delayed(Duration(seconds: 1));
    final token = 'test_token_${DateTime.now().millisecondsSinceEpoch}';
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    return {
      'token': token,
      'user': {'email': email, 'name': 'Test User'}
    };
  }

Future<Map<String, dynamic>> _registerTest(String email, String password, String name, String confirmPassword) async {
  await Future.delayed(Duration(seconds: 1));

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
    await Future.delayed(Duration(milliseconds: 800));
    return Expense(
      id: 'exp_${DateTime.now().millisecondsSinceEpoch}',
      amount: expense.amount,
      description: expense.description,
      date: expense.date,
      category: expense.category
    );
  }

Future<Expense> _updateExpenseTest(String id, Expense expense) async {
 await Future.delayed(Duration(milliseconds: 800));
 return Expense(
   id: id,
   amount: expense.amount,
   description: expense.description, 
   date: expense.date,
   category: expense.category
 );
}

  Future<void> _deleteExpenseTest(String id) async {
    await Future.delayed(Duration(milliseconds: 500));
  }

  Future<List<Expense>> _getExpensesTest() async {
    await Future.delayed(Duration(seconds: 1));
    return [
      Expense(
        id: 'exp_1',
        amount: 45.99,
        description: 'Groceries',
        date: DateTime.now().subtract(Duration(days: 1)),
        category: 'Food'
      ),
      Expense(
        id: 'exp_2',
        amount: 89.99,
        description: 'Gas',
        date: DateTime.now(),
        category: 'Transportation'
      ),
      Expense(
        id: 'exp_3',
        amount: 199.99,
        description: 'Monthly Gym',
        date: DateTime.now().subtract(Duration(days: 2)),
        category: 'Health'
      ),
    ];
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
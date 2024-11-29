// lib/providers/auth_provider.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  String? _token;
  String? _error;

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _token != null;
  String? get error => _error;

  Future<bool> login(String email, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _apiService.login(email, password);
      _token = response['token'];
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
Future<bool> register({
  required String email, 
  required String password,
  required String confirmPassword, 
  required String name
}) async {
  if (password != confirmPassword) {
    _error = "Passwords do not match";
    notifyListeners();
    return false;
  }

  try {
    _isLoading = true;
    _error = null;
    notifyListeners();

    await _apiService.register(email, password, name, confirmPassword);
    final response = await _apiService.login(email, password);
    _token = response['token'];
    _isLoading = false;
    notifyListeners();
    return true;
  } catch (e) {
    _error = e.toString();
    _isLoading = false;
    notifyListeners();
    return false;
  }
}

  void logout() {
    _token = null;
    notifyListeners();
  }
}
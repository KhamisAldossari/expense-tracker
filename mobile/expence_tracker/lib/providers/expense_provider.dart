// lib/providers/expense_provider.dart
import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/api_service.dart';

class ExpenseProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Expense> _expenses = [];
  bool _isLoading = false;
  String? _error;

  List<Expense> get expenses => _expenses;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchExpenses() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _expenses = await _apiService.getExpenses();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addExpense(Expense expense) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final newExpense = await _apiService.addExpense(expense);
      _expenses.add(newExpense);
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

  Future<bool> updateExpense(String id, Expense expense) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final updatedExpense = await _apiService.updateExpense(id, expense);
      final index = _expenses.indexWhere((e) => e.id == id);
      _expenses[index] = updatedExpense;
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

  Future<bool> deleteExpense(String id) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _apiService.deleteExpense(id);
      _expenses.removeWhere((e) => e.id == id);
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

  List<Expense> searchExpenses(String query) {
    return _expenses.where((expense) =>
      expense.description.toLowerCase().contains(query.toLowerCase()) ||
      expense.category.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  List<Expense> filterExpenses({DateTime? date, String? category}) {
    return _expenses.where((expense) {
      bool matchesDate = date == null || 
        (expense.date.year == date.year && 
         expense.date.month == date.month && 
         expense.date.day == date.day);
      
      bool matchesCategory = category == null || 
        expense.category == category;
      
      return matchesDate && matchesCategory;
    }).toList();
  }
}
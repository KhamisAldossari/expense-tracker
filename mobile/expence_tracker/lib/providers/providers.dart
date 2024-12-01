// lib/providers/providers.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/api_service.dart';
import '../models/expense.dart';
import '../models/category.dart';
import '../models/user.dart';
import '../utils/logger.dart';
import '../utils/error_handler.dart';
import '../services/api_service.dart';
import './auth_state.dart';
import './expense_state.dart';

part 'providers.g.dart';

@Riverpod(keepAlive: true)
ApiService apiService(ApiServiceRef ref) => ApiService();

@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  late final Logger _logger;
  late final ApiService _apiService;

  @override
  AuthState build() {
    _logger = ref.read(loggerProvider);
    _apiService = ref.read(apiServiceProvider);
    return AuthState.initial();
  }

  Future<void> login(String email, String password) async {
    _logger.info('Attempting login for: $email');
    state = state.copyWith(isLoading: true, error: null);

    try {
      final authResponse = await _apiService.login(email, password);
      // final authResponse = AuthResponse.fromJson(response);

      _logger.info('Login successful for: ${authResponse.user.email}');

      state = state.copyWith(
        isAuthenticated: true,
        isLoading: false,
        user: authResponse.user,
        token: authResponse.token,
        error: null,
        lastAuthenticated: DateTime.now(),
      );
    } catch (e, stackTrace) {
      _logger.error('Login failed', error: e, stackTrace: stackTrace);
      state = state.copyWith(
        isAuthenticated: false,
        isLoading: false,
        error: e.toString(),
        user: null,
        token: null,
      );
      rethrow;
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String name,
    required String confirmPassword,
  }) async {
    _logger.info('Attempting registration for: $email');
    state = state.copyWith(isLoading: true, error: null);

    try {
      final authResponse = await _apiService.register(
        email: email,
        password: password,
        name: name,
        confirmPassword: confirmPassword,
      );
      // final authResponse = AuthResponse.fromJson(response);

      _logger.info('Registration successful for: ${authResponse.user.email}');

      state = state.copyWith(
        isAuthenticated: true,
        isLoading: false,
        user: authResponse.user,
        token: authResponse.token,
        error: null,
        lastAuthenticated: DateTime.now(),
      );
    } catch (e, stackTrace) {
      _logger.error('Registration failed', error: e, stackTrace: stackTrace);
      state = state.copyWith(
        isAuthenticated: false,
        isLoading: false,
        error: e.toString(),
        user: null,
        token: null,
      );
      rethrow;
    }
  }

  void logout() {
    _logger.info('Logging out user: ${state.user?.email}');
    state = AuthState.initial();
  }
}

@riverpod
class Categories extends _$Categories {
  late final Logger _logger;

  @override
  Future<List<Category>> build() async {
    _logger = ref.read(loggerProvider);
    final authState = ref.watch(authProvider);

    if (!authState.isAuthenticated || authState.token == null) {
      return [];
    }

    try {
      return await ref.read(apiServiceProvider).getCategories(authState.token!);
    } catch (e, stackTrace) {
      _logger.error('Failed to fetch categories', error: e, stackTrace: stackTrace);
      return [];
    }
  }

  Future<void> refresh() async {
    _logger.info('Refreshing categories');
    state = const AsyncValue.loading();

    try {
      final authState = ref.read(authProvider);
      if (!authState.isAuthenticated || authState.token == null) {
        state = const AsyncValue.data([]);
        return;
      }

      final categories = await ref
          .read(apiServiceProvider)
          .getCategories(authState.token!);
      state = AsyncValue.data(categories);
    } catch (e, stackTrace) {
      _logger.error('Failed to refresh categories', error: e, stackTrace: stackTrace);
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

@riverpod
class ExpenseFilters extends _$ExpenseFilters {
  @override
  ({String? category, String? sortBy, String? sortOrder}) build() {
    return (category: null, sortBy: null, sortOrder: null);
  }

  void setCategory(String? category) {
    state = (category: category, sortBy: state.sortBy, sortOrder: state.sortOrder);
  }

  void setSort(String? by, String? order) {
    state = (category: state.category, sortBy: by, sortOrder: order);
  }
}

@riverpod
List<Expense> sortedExpenses(SortedExpensesRef ref) {
  final expenses = ref.watch(expensesProvider).valueOrNull ?? [];
  final filters = ref.watch(expenseFiltersProvider);

  var filteredExpenses = filters.category == null 
    ? expenses 
    : expenses.where((e) => e.category == filters.category).toList();

  if (filters.sortBy != null) {
    final isAscending = filters.sortOrder == 'asc';
    filteredExpenses.sort((a, b) {
      final comparison = switch (filters.sortBy) {
        'date' => a.date.compareTo(b.date),
        'amount' => a.amount.compareTo(b.amount),
        _ => 0,
      };
      return isAscending ? comparison : -comparison;
    });
  }

  return filteredExpenses;
}

@riverpod
class Expenses extends _$Expenses {
  late final Logger _logger;

  @override
  Future<List<Expense>> build() async {
    _logger = ref.read(loggerProvider);
    final authState = ref.watch(authProvider);

    if (!authState.isAuthenticated || authState.token == null) {
      return [];
    }

    try {
      return await ref.read(apiServiceProvider).getExpenses(authState.token!);
    } catch (e, stackTrace) {
      _logger.error('Failed to fetch expenses', error: e, stackTrace: stackTrace);
      return [];
    }
  }

  Future<void> addExpense(Expense expense) async {
    _logger.info('Adding expense: ${expense.description}');
    state = const AsyncValue.loading();

    try {
      final authState = ref.read(authProvider);
      if (!authState.isAuthenticated || authState.token == null) {
        throw UnauthorizedException('Not authenticated');
      }

      await ref.read(apiServiceProvider).addExpense(expense);
      final expenses = await ref.read(apiServiceProvider).getExpenses(authState.token!);
      state = AsyncValue.data(expenses);
    } catch (e, stackTrace) {
      _logger.error('Failed to add expense', error: e, stackTrace: stackTrace);
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updateExpense(Expense expense) async {
    if (expense.id == null) throw ValidationException('Expense ID is required for update');
    _logger.info('Updating expense: ${expense.id}');
    state = const AsyncValue.loading();

    try {
      final authState = ref.read(authProvider);
      if (!authState.isAuthenticated || authState.token == null) {
        throw UnauthorizedException('Not authenticated');
      }

      await ref.read(apiServiceProvider).updateExpense(expense.id!, expense);
      final expenses = await ref.read(apiServiceProvider).getExpenses(authState.token!);
      state = AsyncValue.data(expenses);
    } catch (e, stackTrace) {
      _logger.error('Failed to update expense', error: e, stackTrace: stackTrace);
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> deleteExpense(String id) async {
    _logger.info('Deleting expense: $id');
    state = const AsyncValue.loading();

    try {
      final authState = ref.read(authProvider);
      if (!authState.isAuthenticated || authState.token == null) {
        throw UnauthorizedException('Not authenticated');
      }

      await ref.read(apiServiceProvider).deleteExpense(id);
      final expenses = await ref.read(apiServiceProvider).getExpenses(authState.token!);
      state = AsyncValue.data(expenses);
    } catch (e, stackTrace) {
      _logger.error('Failed to delete expense', error: e, stackTrace: stackTrace);
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
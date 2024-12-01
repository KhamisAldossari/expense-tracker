// lib/providers/expense_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/expense.dart';
import '../utils/logger.dart';
import './providers.dart';
import './auth_state.dart';

part 'expense_state.g.dart';
part 'expense_state.freezed.dart';

@freezed
class ExpenseFilterState with _$ExpenseFilterState {
  const factory ExpenseFilterState({
    String? category,
    String? sortBy,
    String? sortOrder,
  }) = _ExpenseFilterState;

  const ExpenseFilterState._();

  factory ExpenseFilterState.initial() => const ExpenseFilterState();
}

@riverpod
class ExpenseFilters extends _$ExpenseFilters {
  late final Logger _logger;

  @override
  ExpenseFilterState build() {
    _logger = ref.read(loggerProvider);
    return ExpenseFilterState.initial();
  }

  void setCategory(String? category) {
    _logger.debug('Setting expense category filter: $category');
    state = state.copyWith(category: category);
  }

  void setSort(String? by, String? order) {
    _logger.debug('Setting expense sort: $by, $order');
    state = state.copyWith(
      sortBy: by,
      sortOrder: order,
    );
  }

  void resetFilters() {
    _logger.debug('Resetting expense filters');
    state = ExpenseFilterState.initial();
  }
}

class ExpenseException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  ExpenseException(this.message, {this.code, this.originalError});

  @override
  String toString() => message;
}

@riverpod
class ExpenseOperations extends _$ExpenseOperations {
  late final Logger _logger;

  @override
  Future<void> build() async {
    _logger = ref.read(loggerProvider);
  }

  Future<void> addExpense(Expense expense) async {
    _logger.info('Adding expense: ${expense.description}');
    state = const AsyncValue.loading();

    try {
      final authState = ref.read(authProvider);
      if (!authState.isAuthenticated) {
        throw AuthException(
          'Not authenticated',
          type: AuthErrorType.unauthorized,
        );
      }

      await ref.read(apiServiceProvider).addExpense(expense);
      await ref.refresh(expensesProvider.future);
      
      _logger.info('Expense added successfully: ${expense.id}');
      state = const AsyncValue.data(null);
    } catch (e, st) {
      _logger.error(
        'Failed to add expense',
        error: e,
        stackTrace: st,
      );
      
      final error = _handleExpenseError(e);
      state = AsyncValue.error(error, st);
    }
  }

  Future<void> updateExpense(Expense expense) async {
    if (expense.id == null) {
      throw ExpenseException('Expense ID is required for update');
    }

    _logger.info('Updating expense: ${expense.id}');
    state = const AsyncValue.loading();

    try {
      final authState = ref.read(authProvider);
      if (!authState.isAuthenticated) {
        throw AuthException(
          'Not authenticated',
          type: AuthErrorType.unauthorized,
        );
      }

      await ref.read(apiServiceProvider).updateExpense(expense.id!, expense);
      await ref.refresh(expensesProvider.future);

      _logger.info('Expense updated successfully: ${expense.id}');
      state = const AsyncValue.data(null);
    } catch (e, st) {
      _logger.error(
        'Failed to update expense',
        error: e,
        stackTrace: st,
      );

      final error = _handleExpenseError(e);
      state = AsyncValue.error(error, st);
    }
  }

  Future<void> deleteExpense(String id) async {
    _logger.info('Deleting expense: $id');
    state = const AsyncValue.loading();

    try {
      final authState = ref.read(authProvider);
      if (!authState.isAuthenticated) {
        throw AuthException(
          'Not authenticated',
          type: AuthErrorType.unauthorized,
        );
      }

      await ref.read(apiServiceProvider).deleteExpense(id);
      await ref.refresh(expensesProvider.future);

      _logger.info('Expense deleted successfully: $id');
      state = const AsyncValue.data(null);
    } catch (e, st) {
      _logger.error(
        'Failed to delete expense',
        error: e,
        stackTrace: st,
      );

      final error = _handleExpenseError(e);
      state = AsyncValue.error(error, st);
    }
  }

  ExpenseException _handleExpenseError(dynamic error) {
    if (error is AuthException) {
      return ExpenseException(
        'Authentication error: ${error.message}',
        code: 'AUTH_ERROR',
        originalError: error,
      );
    }

    if (error is ExpenseException) {
      return error;
    }

    return ExpenseException(
      'An unexpected error occurred while managing the expense',
      code: 'UNKNOWN_ERROR',
      originalError: error,
    );
  }
}
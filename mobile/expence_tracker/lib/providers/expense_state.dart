// lib/providers/expense_state.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/expense.dart';
import './providers.dart';

part 'expense_state.g.dart';

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
class ExpenseOperations extends _$ExpenseOperations {
  @override
  Future<void> build() async {}

  Future<void> addExpense(Expense expense) async {
    state = const AsyncValue.loading();
    try {
      final token = await ref.read(authProvider.future);
      if (token == null) throw Exception('Not authenticated');
      await ref.read(apiServiceProvider).addExpense(expense);
      await ref.refresh(expensesProvider.future);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateExpense(Expense expense) async {
    if (expense.id == null) throw Exception('Expense ID is required for update');
    state = const AsyncValue.loading();
    try {
      final token = await ref.read(authProvider.future);
      if (token == null) throw Exception('Not authenticated');
      await ref.read(apiServiceProvider).updateExpense(expense.id!, expense);
      await ref.refresh(expensesProvider.future);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteExpense(String id) async {
    state = const AsyncValue.loading();
    try {
      final token = await ref.read(authProvider.future);
      if (token == null) throw Exception('Not authenticated');
      await ref.read(apiServiceProvider).deleteExpense(id);
      await ref.refresh(expensesProvider.future);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
// lib/providers/providers.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/api_service.dart';
import '../models/expense.dart';
import '../models/category.dart';

part 'providers.g.dart';

@riverpod
ApiService apiService(ApiServiceRef ref) => ApiService();

@riverpod
class Auth extends _$Auth {
  @override
  FutureOr<String?> build() async => null;

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final response = await ref.read(apiServiceProvider).login(email, password);
      state = AsyncValue.data(response['token']);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String name,
    required String confirmPassword,
  }) async {
    state = const AsyncValue.loading();
    try {
      final response = await ref.read(apiServiceProvider).register(
        email: email,
        password: password,
        name: name,
        confirmPassword: confirmPassword,
      );
      state = AsyncValue.data(response['token']);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void logout() => state = const AsyncValue.data(null);
}

@riverpod
class Categories extends _$Categories {
  @override
  Future<List<Category>> build() async {
    final token = await ref.watch(authProvider.future);
    if (token == null) return [];
    return ref.read(apiServiceProvider).getCategories(token);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    try {
      final token = await ref.read(authProvider.future);
      if (token == null) {
        state = const AsyncValue.data([]);
        return;
      }
      final categories = await ref.read(apiServiceProvider).getCategories(token);
      state = AsyncValue.data(categories);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
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
  @override
  Future<List<Expense>> build() async {
    final token = await ref.watch(authProvider.future);
    if (token == null) return [];
    return ref.read(apiServiceProvider).getExpenses(token);
  }

  Future<void> addExpense(Expense expense) async {
    state = const AsyncValue.loading();
    try {
      final token = await ref.read(authProvider.future);
      if (token == null) throw Exception('Not authenticated');
      await ref.read(apiServiceProvider).addExpense(expense);
      final expenses = await ref.read(apiServiceProvider).getExpenses(token);
      state = AsyncValue.data(expenses);
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
      final expenses = await ref.read(apiServiceProvider).getExpenses(token);
      state = AsyncValue.data(expenses);
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
      final expenses = await ref.read(apiServiceProvider).getExpenses(token);
      state = AsyncValue.data(expenses);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
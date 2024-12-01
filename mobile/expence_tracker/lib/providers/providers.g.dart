// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$apiServiceHash() => r'5b8beddb448316bdae5e3963ff77601653715729';

/// See also [apiService].
@ProviderFor(apiService)
final apiServiceProvider = Provider<ApiService>.internal(
  apiService,
  name: r'apiServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$apiServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ApiServiceRef = ProviderRef<ApiService>;
String _$sortedExpensesHash() => r'62d3926c507afcac6bc0800b7236d36f8a2de929';

/// See also [sortedExpenses].
@ProviderFor(sortedExpenses)
final sortedExpensesProvider = AutoDisposeProvider<List<Expense>>.internal(
  sortedExpenses,
  name: r'sortedExpensesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sortedExpensesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SortedExpensesRef = AutoDisposeProviderRef<List<Expense>>;
String _$authHash() => r'1c73b94dd65a1f8407d9c2c3422ad3f153e97f37';

/// See also [Auth].
@ProviderFor(Auth)
final authProvider = NotifierProvider<Auth, AuthState>.internal(
  Auth.new,
  name: r'authProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Auth = Notifier<AuthState>;
String _$categoriesHash() => r'cfeaa709870b7e5e631cb6d319d0512486d1a425';

/// See also [Categories].
@ProviderFor(Categories)
final categoriesProvider =
    AutoDisposeAsyncNotifierProvider<Categories, List<Category>>.internal(
  Categories.new,
  name: r'categoriesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$categoriesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Categories = AutoDisposeAsyncNotifier<List<Category>>;
String _$expenseFiltersHash() => r'16f9434e9d5cb8c90a597dfb1d4216ea6c6bd12d';

/// See also [ExpenseFilters].
@ProviderFor(ExpenseFilters)
final expenseFiltersProvider = AutoDisposeNotifierProvider<ExpenseFilters,
    ({String? category, String? sortBy, String? sortOrder})>.internal(
  ExpenseFilters.new,
  name: r'expenseFiltersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$expenseFiltersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ExpenseFilters = AutoDisposeNotifier<
    ({String? category, String? sortBy, String? sortOrder})>;
String _$expensesHash() => r'b63853ce8ef6cbb2af006b2a3cb624ff3cd29ae6';

/// See also [Expenses].
@ProviderFor(Expenses)
final expensesProvider =
    AutoDisposeAsyncNotifierProvider<Expenses, List<Expense>>.internal(
  Expenses.new,
  name: r'expensesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$expensesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Expenses = AutoDisposeAsyncNotifier<List<Expense>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

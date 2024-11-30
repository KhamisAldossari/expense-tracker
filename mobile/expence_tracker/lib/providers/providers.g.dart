// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$apiServiceHash() => r'73ad3c2e8c0d458c43bdd728c0f0fb75c5c2af98';

/// See also [apiService].
@ProviderFor(apiService)
final apiServiceProvider = AutoDisposeProvider<ApiService>.internal(
  apiService,
  name: r'apiServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$apiServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ApiServiceRef = AutoDisposeProviderRef<ApiService>;
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
String _$authHash() => r'd43509b2efcb167eef0a63330bb4af95baad21ef';

/// See also [Auth].
@ProviderFor(Auth)
final authProvider = AutoDisposeAsyncNotifierProvider<Auth, String?>.internal(
  Auth.new,
  name: r'authProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Auth = AutoDisposeAsyncNotifier<String?>;
String _$categoriesHash() => r'f75ce55069b49a4b3b3229bbbeeb1f4d68e61e66';

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
String _$expensesHash() => r'faec9d46db4162726b68dbeb65cced47411b533c';

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

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

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
String _$expenseOperationsHash() => r'8e74c132bf4c222faad80ad93f36893d8e3479c3';

/// See also [ExpenseOperations].
@ProviderFor(ExpenseOperations)
final expenseOperationsProvider =
    AutoDisposeAsyncNotifierProvider<ExpenseOperations, void>.internal(
  ExpenseOperations.new,
  name: r'expenseOperationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$expenseOperationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ExpenseOperations = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

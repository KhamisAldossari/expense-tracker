// lib/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/category.dart';
import '../../models/expense.dart';
import '../../providers/providers.dart';
import '../../widgets/expense_list_item.dart';
import '../../widgets/footer.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(sortedExpensesProvider);
    final categories = ref.watch(categoriesProvider);
    final currentFilters = ref.watch(expenseFiltersProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              ref.read(authProvider.notifier).logout();
              context.go('/login');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _CategoryFilter(
                    categories: categories,
                    currentCategory: currentFilters.category,
                    onChanged: (category) => ref
                        .read(expenseFiltersProvider.notifier)
                        .setCategory(category),
                  ),
                ),
                const SizedBox(width: 16),
                _SortButton(
                  currentSortBy: currentFilters.sortBy,
                  currentSortOrder: currentFilters.sortOrder,
                  onSortChanged: (sortBy, sortOrder) => ref
                      .read(expenseFiltersProvider.notifier)
                      .setSort(sortBy, sortOrder),
                ),
              ],
            ),
          ),
          Expanded(
            child: ref.watch(expensesProvider).when(
              data: (_) => _ExpenseList(expenses: expenses),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load expenses: ${error.toString()}',
                      textAlign: TextAlign.center,
                    ),
                    TextButton(
                      onPressed: () => ref.invalidate(expensesProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (expenses.isNotEmpty) _buildSummary(expenses),
          const Footer(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed('addExpense'),
        label: const Text('Add Expense'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummary(List<Expense> expenses) {
    final total = expenses.fold<double>(0, (sum, expense) => sum + expense.amount);
    final average = expenses.isEmpty ? 0.0 : total / expenses.length;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _SummaryItem(
              title: 'Total',
              amount: total,
              icon: Icons.account_balance_wallet,
            ),
            _SummaryItem(
              title: 'Average',
              amount: average,
              icon: Icons.show_chart,
            ),
            _SummaryItem(
              title: 'Count',
              amount: expenses.length.toDouble(),
              icon: Icons.receipt_long,
              isCount: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryFilter extends StatelessWidget {
  final AsyncValue<List<Category>> categories;
  final String? currentCategory;
  final ValueChanged<String?> onChanged;

  const _CategoryFilter({
    required this.categories,
    required this.currentCategory,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return categories.when(
      data: (cats) => Card(
        child: DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Filter by Category',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 16),
          ),
          value: currentCategory,
          items: [
            const DropdownMenuItem(
              value: null,
              child: Text('All Categories'),
            ),
            ...cats.map((category) => DropdownMenuItem(
              value: category.id,
              child: Text(category.name),
            )),
          ],
          onChanged: onChanged,
        ),
      ),
      loading: () => const LinearProgressIndicator(),
      error: (_, __) => const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('Failed to load categories'),
        ),
      ),
    );
  }
}

class _SortButton extends StatelessWidget {
  final String? currentSortBy;
  final String? currentSortOrder;
  final void Function(String?, String?) onSortChanged;

  const _SortButton({
    required this.currentSortBy,
    required this.currentSortOrder,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    final String buttonText = switch ((currentSortBy, currentSortOrder)) {
      (null, _) => 'Sort By',
      ('date', 'asc') => 'Date ↑',
      ('date', 'desc') => 'Date ↓',
      ('amount', 'asc') => 'Amount ↑',
      ('amount', 'desc') => 'Amount ↓',
      _ => 'Sort By',
    };

    return PopupMenuButton<(String, String)>(
      child: Chip(
        avatar: const Icon(Icons.sort),
        label: Text(buttonText),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: ('date', currentSortBy == 'date' && currentSortOrder == 'asc' ? 'desc' : 'asc'),
          child: _SortMenuItem(
            icon: Icons.calendar_today,
            label: 'Date',
            isSelected: currentSortBy == 'date',
            isAscending: currentSortBy == 'date' && currentSortOrder == 'asc',
          ),
        ),
        PopupMenuItem(
          value: ('amount', currentSortBy == 'amount' && currentSortOrder == 'asc' ? 'desc' : 'asc'),
          child: _SortMenuItem(
            icon: Icons.monetization_on,
            label: 'Amount',
            isSelected: currentSortBy == 'amount',
            isAscending: currentSortBy == 'amount' && currentSortOrder == 'asc',
          ),
        ),
      ],
      onSelected: (value) => onSortChanged(value.$1, value.$2),
    );
  }
}

class _SortMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final bool isAscending;

  const _SortMenuItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.isAscending,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Text(label),
          ],
        ),
        if (isSelected)
          Icon(isAscending ? Icons.arrow_upward : Icons.arrow_downward),
      ],
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String title;
  final double amount;
  final IconData icon;
  final bool isCount;

  const _SummaryItem({
    required this.title,
    required this.amount,
    required this.icon,
    this.isCount = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Theme.of(context).primaryColor),
        const SizedBox(height: 8),
        Text(title, style: Theme.of(context).textTheme.titleSmall),
        Text(
          isCount ? amount.toInt().toString() : '\$${amount.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _ExpenseList extends StatelessWidget {
  final List<Expense> expenses;

  const _ExpenseList({required this.expenses});

  @override
  Widget build(BuildContext context) {
    if (expenses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.receipt_long, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'No expenses found',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.grey,
              ),
            ),
            TextButton.icon(
              onPressed: () => context.pushNamed('addExpense'),
              icon: const Icon(Icons.add),
              label: const Text('Add your first expense'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80), // Space for FAB
      itemCount: expenses.length,
      itemBuilder: (context, index) => ExpenseListItem(
        expense: expenses[index],
      ),
    );
  }
}
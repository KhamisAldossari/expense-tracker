// lib/widgets/expense_list_item.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import '../models/category.dart';
import '../providers/providers.dart';

class ExpenseListItem extends ConsumerWidget {
  final Expense expense;

  const ExpenseListItem({super.key, required this.expense});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);

    return Dismissible(
      key: Key(expense.id!),
      confirmDismiss: (_) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete Expense'),
          content: const Text('Are you sure you want to delete this expense?'),
          actions: [
            TextButton(
              onPressed: () => context.pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => context.pop(true),
              child: const Text('Delete'),
            ),
          ],
        ),
      ),
      onDismissed: (_) => ref.read(expensesProvider.notifier).deleteExpense(expense.id!),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListTile(
          leading: categories.when(
            data: (cats) {
              final category = cats.firstWhere(
                (c) => c.id == expense.category,
                orElse: () => const Category(id: '', name: 'Unknown'),
              );
              return CircleAvatar(child: Text(category.name[0]));
            },
            loading: () => const CircularProgressIndicator(),
            error: (_, __) => const Icon(Icons.error),
          ),
          title: Text(expense.description),
          subtitle: Text(DateFormat('MMM d, y').format(expense.date)),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${expense.amount.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                DateFormat('h:mm a').format(expense.date),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          onTap: () => context.push('/expense/${expense.id}'),
        ),
      ),
    );
  }
}
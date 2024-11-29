// lib/widgets/expense_list_item.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/expense.dart';
import '../providers/expense_provider.dart';
import '../screens/expense/add_edit_expense_screen.dart';

class ExpenseListItem extends StatelessWidget {
  final Expense expense;

  const ExpenseListItem({Key? key, required this.expense}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(expense.id!),
      confirmDismiss: (_) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete Expense'),
          content: const Text('Are you sure you want to delete this expense?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context, false),
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        ),
      ),
      onDismissed: (_) {
        Provider.of<ExpenseProvider>(context, listen: false)
            .deleteExpense(expense.id!);
      },
      child: ListTile(
        title: Text(expense.description),
        subtitle: Text('${expense.category} - ${expense.date.toString()}'),
        trailing: Text('\$${expense.amount.toStringAsFixed(2)}'),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddEditExpenseScreen(expense: expense),
          ),
        ),
      ),
    );
  }
}
// lib/screens/expense/expense_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../models/expense.dart';
import '../../providers/providers.dart';

class ExpenseFormScreen extends ConsumerStatefulWidget {
  final String? expenseId;
  
  const ExpenseFormScreen({super.key, this.expenseId});

  @override
  ConsumerState<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends ConsumerState<ExpenseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String? _selectedCategoryId;

  Expense? get _expense {
    final expenses = ref.read(expensesProvider).value;
    if (expenses == null || widget.expenseId == null) return null;
    
    try {
      return expenses.firstWhere((e) => e.id == widget.expenseId);
    } catch (_) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    final currentExpense = _expense;
    if (currentExpense != null) {
      _amountController.text = currentExpense.amount.toString();
      _descriptionController.text = currentExpense.description;
      _selectedDate = currentExpense.date;
      _selectedCategoryId = currentExpense.category;
    }
  }

  
  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.expenseId == null ? 'Add Expense' : 'Edit Expense'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Amount is required';
                  if (double.tryParse(value!) == null) return 'Invalid amount';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              categories.when(
                data: (cats) => DropdownButtonFormField<String>(
                  value: _selectedCategoryId,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    prefixIcon: Icon(Icons.category),
                  ),
                  items: cats.map((cat) => DropdownMenuItem(
                    value: cat.id,
                    child: Text(cat.name),
                  )).toList(),
                  onChanged: (value) => setState(() => _selectedCategoryId = value),
                  validator: (value) => value == null ? 'Category is required' : null,
                ),
                loading: () => const LinearProgressIndicator(),
                error: (_, __) => const Text('Failed to load categories'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  prefixIcon: Icon(Icons.description),
                  alignLabelWithHint: true,
                ),
                validator: (value) => 
                    value?.isEmpty ?? true ? 'Description is required' : null,
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Date'),
                subtitle: Text(DateFormat('MMM d, y').format(_selectedDate)),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    setState(() => _selectedDate = date);
                  }
                },
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Save Expense'),
                onPressed: _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final expense = Expense(
        id: _expense?.id,
        amount: double.parse(_amountController.text),
        category: _selectedCategoryId!,
        date: _selectedDate,
        description: _descriptionController.text,
      );

      if (widget.expenseId != null) {
        await ref.read(expensesProvider.notifier).updateExpense(expense);
      } else {
        await ref.read(expensesProvider.notifier).addExpense(expense);
      }

      if (mounted && !ref.read(expensesProvider).hasError) {
        context.pop();
      }
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
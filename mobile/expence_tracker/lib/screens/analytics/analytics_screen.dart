// lib/screens/analytics/expense_analytics_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../models/expense.dart';
import '../../models/category.dart';
import '../../providers/providers.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(expensesProvider);
    final categories = ref.watch(categoriesProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Analytics'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Trends'),
              Tab(text: 'Categories'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _TrendsTab(expenses: expenses),
            _CategoriesTab(expenses: expenses, categories: categories),
          ],
        ),
      ),
    );
  }
}

class _TrendsTab extends StatelessWidget {
  final AsyncValue<List<Expense>> expenses;

  const _TrendsTab({required this.expenses});

  @override
  Widget build(BuildContext context) {
    return expenses.when(
      data: (data) {
        final monthlyData = _calculateMonthlyData(data);
        
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(
                height: 300,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: true),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) => Text(
                            value.toInt() < monthlyData.length 
                              ? DateFormat('MMM').format(monthlyData[value.toInt()].date)
                              : '',
                          ),
                        ),
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(
                          monthlyData.length,
                          (i) => FlSpot(i.toDouble(), monthlyData[i].total),
                        ),
                        isCurved: true,
                        color: Theme.of(context).primaryColor,
                        dotData: FlDotData(show: true),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _StatisticsCard(expenses: data),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text(error.toString())),
    );
  }

  List<({DateTime date, double total})> _calculateMonthlyData(List<Expense> expenses) {
    final monthlyTotals = <DateTime, double>{};
    
    for (final expense in expenses) {
      final date = DateTime(expense.date.year, expense.date.month);
      monthlyTotals[date] = (monthlyTotals[date] ?? 0) + expense.amount;
    }
    
    final sortedEntries = monthlyTotals.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    
    return sortedEntries
      .map((e) => (date: e.key, total: e.value))
      .toList();
  }
}

class _CategoriesTab extends StatelessWidget {
  final AsyncValue<List<Expense>> expenses;
  final AsyncValue<List<Category>> categories;

  const _CategoriesTab({required this.expenses, required this.categories});

@override
Widget build(BuildContext context) {
  return expenses.when(
    data: (expenseData) => categories.when(
      data: (categoryData) {
        final categoryTotals = _calculateCategoryTotals(expenseData, categoryData);
        final totalAmount = categoryTotals.fold(0.0, (sum, item) => sum + item.amount);

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0), 
              child: SizedBox(
                height: 300,
                child: PieChart(
                  PieChartData(
                    sections: categoryTotals.map((item) {
                      final percentage = (item.amount / totalAmount * 100);
                      return PieChartSectionData(
                        value: item.amount,
                        title: '${percentage.toStringAsFixed(1)}%',
                        radius: 100,
                        color: Colors.primaries[categoryTotals.indexOf(item) % Colors.primaries.length],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: categoryTotals.length,
                itemBuilder: (context, index) {
                  final item = categoryTotals[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.primaries[index % Colors.primaries.length],
                    ),
                    title: Text(item.name),
                    trailing: Text('\$${item.amount.toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text(error.toString())),
    ),
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (error, _) => Center(child: Text(error.toString())),
  );
}

  List<({String name, double amount})> _calculateCategoryTotals(
    List<Expense> expenses,
    List<Category> categories,
  ) {
    final totals = <String, double>{};
    final categoryMap = {for (var c in categories) c.id: c};

    for (final expense in expenses) {
      totals[expense.category] = (totals[expense.category] ?? 0) + expense.amount;
    }

    return totals.entries
      .map((e) => (
        name: categoryMap[e.key]?.name ?? 'Unknown',
        amount: e.value,
      ))
      .toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));
  }
}

class _StatisticsCard extends StatelessWidget {
  final List<Expense> expenses;

  const _StatisticsCard({required this.expenses});

  @override
  Widget build(BuildContext context) {
    final total = expenses.fold(0.0, (sum, e) => sum + e.amount);
    final average = expenses.isEmpty ? 0.0 : total / expenses.length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.monetization_on),
              title: const Text('Total Expenses'),
              trailing: Text(
                '\$${total.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.trending_up),
              title: const Text('Average Expense'),
              trailing: Text(
                '\$${average.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
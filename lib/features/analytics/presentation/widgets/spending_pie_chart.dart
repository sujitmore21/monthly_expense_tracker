import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../expenses/data/models/expense_model.dart';
import '../../../expenses/data/models/category_model.dart';

class SpendingPieChart extends StatelessWidget {
  final List<ExpenseModel> expenses;
  final List<CategoryModel> categories;
  final DateTime month;

  const SpendingPieChart({
    super.key,
    required this.expenses,
    required this.categories,
    required this.month,
  });

  @override
  Widget build(BuildContext context) {
    final categorySpending = _calculateCategorySpending();

    if (categorySpending.isEmpty) {
      return _buildEmptyState(context);
    }

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Spending by Category',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: PieChart(
                      PieChartData(
                        sections: _buildPieChartSections(categorySpending),
                        centerSpaceRadius: 40,
                        sectionsSpace: 2,
                      ),
                    ),
                  ),
                  Expanded(flex: 1, child: _buildLegend(categorySpending)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(Icons.pie_chart_outline, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No Spending Data',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Add some expenses to see your spending breakdown.',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, double> _calculateCategorySpending() {
    final Map<String, double> categorySpending = {};

    for (final expense in expenses) {
      categorySpending[expense.categoryId] =
          (categorySpending[expense.categoryId] ?? 0) + expense.amount;
    }

    return categorySpending;
  }

  List<PieChartSectionData> _buildPieChartSections(
    Map<String, double> categorySpending,
  ) {
    final List<Color> colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
      Colors.amber,
      Colors.cyan,
    ];

    final totalSpending = categorySpending.values.fold(
      0.0,
      (sum, amount) => sum + amount,
    );
    final List<PieChartSectionData> sections = [];

    int colorIndex = 0;
    for (final entry in categorySpending.entries) {
      final category = _getCategoryById(entry.key);
      final percentage = (entry.value / totalSpending) * 100;

      sections.add(
        PieChartSectionData(
          color: colors[colorIndex % colors.length],
          value: entry.value,
          title: '${percentage.toStringAsFixed(1)}%',
          radius: 60,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
      colorIndex++;
    }

    return sections;
  }

  Widget _buildLegend(Map<String, double> categorySpending) {
    final List<Color> colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
      Colors.amber,
      Colors.cyan,
    ];

    final totalSpending = categorySpending.values.fold(
      0.0,
      (sum, amount) => sum + amount,
    );
    final List<Widget> legendItems = [];

    int colorIndex = 0;
    for (final entry in categorySpending.entries) {
      final category = _getCategoryById(entry.key);
      final percentage = (entry.value / totalSpending) * 100;

      legendItems.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: colors[colorIndex % colors.length],
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category?.name ?? 'Unknown',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '\$${entry.value.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
      colorIndex++;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: legendItems,
    );
  }

  CategoryModel? _getCategoryById(String categoryId) {
    try {
      return categories.firstWhere((category) => category.id == categoryId);
    } catch (e) {
      return null;
    }
  }
}

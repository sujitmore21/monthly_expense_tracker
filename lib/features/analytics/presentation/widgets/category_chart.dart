import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/analytics_provider.dart';

class CategoryChart extends ConsumerWidget {
  final DateTime month;

  const CategoryChart({super.key, required this.month});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesByCategoryAsync = ref.watch(
      expensesByCategoryProvider(month),
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: expensesByCategoryAsync.when(
          data: (categoryExpenses) {
            if (categoryExpenses.isEmpty) {
              return const SizedBox(
                height: 200,
                child: Center(child: Text('No data available')),
              );
            }

            // Convert to pie chart data
            final total = categoryExpenses.values.fold(
              0.0,
              (sum, amount) => sum + amount,
            );
            final pieData = categoryExpenses.entries.map((entry) {
              final percentage = (entry.value / total * 100).round();
              return PieChartSectionData(
                color: _getColorForCategory(entry.key),
                value: entry.value,
                title: '${entry.key}\n$percentage%',
                radius: 60,
                titleStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              );
            }).toList();

            return SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: pieData,
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
            );
          },
          loading: () => const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, stack) => SizedBox(
            height: 200,
            child: Center(child: Text('Error: $error')),
          ),
        ),
      ),
    );
  }

  Color _getColorForCategory(String category) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
    ];

    final index = category.hashCode % colors.length;
    return colors[index];
  }
}

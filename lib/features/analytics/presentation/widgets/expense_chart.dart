import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/analytics_provider.dart';

class ExpenseChart extends ConsumerWidget {
  final DateTime month;

  const ExpenseChart({super.key, required this.month});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyExpensesAsync = ref.watch(dailyExpensesProvider(month));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: dailyExpensesAsync.when(
          data: (dailyExpenses) {
            if (dailyExpenses.isEmpty) {
              return const SizedBox(
                height: 200,
                child: Center(child: Text('No data available')),
              );
            }

            // Create data points for the chart
            final spots = <FlSpot>[];
            final daysInMonth = DateTime(month.year, month.month + 1, 0).day;

            for (int day = 1; day <= daysInMonth; day++) {
              final date = DateTime(month.year, month.month, day);
              final dateKey = date.toString().split(' ')[0];
              final amount = dailyExpenses[dateKey] ?? 0.0;
              spots.add(FlSpot(day.toDouble(), amount));
            }

            return SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '\$${value.toInt()}',
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() % 5 == 0) {
                            return Text(
                              value.toInt().toString(),
                              style: const TextStyle(fontSize: 10),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: Theme.of(context).colorScheme.primary,
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.1),
                      ),
                    ),
                  ],
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
}

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../expenses/data/models/expense_model.dart';

class SpendingTrendChart extends StatelessWidget {
  final List<ExpenseModel> expenses;
  final DateTime startDate;
  final DateTime endDate;

  const SpendingTrendChart({
    super.key,
    required this.expenses,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    final dailySpending = _calculateDailySpending();

    if (dailySpending.isEmpty) {
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
              'Spending Trend',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: 1,
                    verticalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(color: Colors.grey[300]!, strokeWidth: 1);
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(color: Colors.grey[300]!, strokeWidth: 1);
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          return _buildBottomTitle(value, meta, dailySpending);
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          return _buildLeftTitle(value, meta);
                        },
                        reservedSize: 40,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  minX: 0,
                  maxX: dailySpending.length - 1.toDouble(),
                  minY: 0,
                  maxY: _getMaxSpending(dailySpending),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _buildSpots(dailySpending),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: Colors.blue,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.blue.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildSummary(context, dailySpending),
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
            Icon(Icons.trending_up, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No Spending Data',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Add some expenses to see your spending trends.',
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

  Map<DateTime, double> _calculateDailySpending() {
    final Map<DateTime, double> dailySpending = {};

    for (final expense in expenses) {
      final date = DateTime(
        expense.date.year,
        expense.date.month,
        expense.date.day,
      );
      dailySpending[date] = (dailySpending[date] ?? 0) + expense.amount;
    }

    return dailySpending;
  }

  List<FlSpot> _buildSpots(Map<DateTime, double> dailySpending) {
    final List<FlSpot> spots = [];
    final sortedDates = dailySpending.keys.toList()..sort();

    for (int i = 0; i < sortedDates.length; i++) {
      spots.add(FlSpot(i.toDouble(), dailySpending[sortedDates[i]]!));
    }

    return spots;
  }

  double _getMaxSpending(Map<DateTime, double> dailySpending) {
    if (dailySpending.isEmpty) return 100;
    final maxValue = dailySpending.values.reduce((a, b) => a > b ? a : b);
    return (maxValue * 1.1).ceilToDouble(); // Add 10% padding
  }

  Widget _buildBottomTitle(
    double value,
    TitleMeta meta,
    Map<DateTime, double> dailySpending,
  ) {
    if (value.toInt() >= 0 && value.toInt() < dailySpending.length) {
      final sortedDates = dailySpending.keys.toList()..sort();
      final date = sortedDates[value.toInt()];
      return Text(
        DateFormat('MMM dd').format(date),
        style: const TextStyle(fontSize: 10),
      );
    }
    return const Text('');
  }

  Widget _buildLeftTitle(double value, TitleMeta meta) {
    return Text('₹${value.toInt()}', style: const TextStyle(fontSize: 10));
  }

  Widget _buildSummary(
    BuildContext context,
    Map<DateTime, double> dailySpending,
  ) {
    final totalSpending = dailySpending.values.fold(
      0.0,
      (sum, amount) => sum + amount,
    );
    final averageSpending = totalSpending / dailySpending.length;
    final maxSpending = dailySpending.values.fold(0.0, (a, b) => a > b ? a : b);
    final minSpending = dailySpending.values.fold(
      double.infinity,
      (a, b) => a < b ? a : b,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildSummaryItem(
          context,
          'Total',
          '₹${totalSpending.toStringAsFixed(2)}',
          Colors.blue,
        ),
        _buildSummaryItem(
          context,
          'Average',
          '₹${averageSpending.toStringAsFixed(2)}',
          Colors.green,
        ),
        _buildSummaryItem(
          context,
          'Highest',
          '₹${maxSpending.toStringAsFixed(2)}',
          Colors.orange,
        ),
        _buildSummaryItem(
          context,
          'Lowest',
          '₹${minSpending.toStringAsFixed(2)}',
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildSummaryItem(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/analytics_provider.dart';

class MonthlySummary extends ConsumerWidget {
  final DateTime month;

  const MonthlySummary({super.key, required this.month});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalExpensesAsync = ref.watch(totalMonthlyExpensesProvider(month));
    final expensesByCategoryAsync = ref.watch(
      expensesByCategoryProvider(month),
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monthly Summary',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            totalExpensesAsync.when(
              data: (total) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSummaryItem(
                    context,
                    'Total Spent',
                    '\$${total.toStringAsFixed(2)}',
                    Icons.account_balance_wallet,
                    Theme.of(context).colorScheme.primary,
                  ),
                  _buildSummaryItem(
                    context,
                    'Transactions',
                    '${_getTransactionCount(expensesByCategoryAsync)}',
                    Icons.receipt,
                    Theme.of(context).colorScheme.secondary,
                  ),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Text('Error: $error'),
            ),
            const SizedBox(height: 16),
            expensesByCategoryAsync.when(
              data: (categoryExpenses) {
                if (categoryExpenses.isEmpty) {
                  return const Text('No expenses this month');
                }

                // Get top 3 categories
                final sortedCategories = categoryExpenses.entries.toList()
                  ..sort((a, b) => b.value.compareTo(a.value));

                final topCategories = sortedCategories.take(3).toList();
                final total = categoryExpenses.values.fold(
                  0.0,
                  (sum, amount) => sum + amount,
                );

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Top Categories',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...topCategories.map((entry) {
                      final percentage = (entry.value / total * 100).round();
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(entry.key),
                            Text(
                              '\$${entry.value.toStringAsFixed(2)} ($percentage%)',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => Text('Error: $error'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }

  int _getTransactionCount(
    AsyncValue<Map<String, double>> categoryExpensesAsync,
  ) {
    return categoryExpensesAsync.when(
      data: (categoryExpenses) => categoryExpenses.length,
      loading: () => 0,
      error: (_, __) => 0,
    );
  }
}

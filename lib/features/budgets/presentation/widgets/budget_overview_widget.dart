import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/budget_model.dart';
import '../providers/budget_provider.dart';
import 'budget_progress_widget.dart';

class BudgetOverviewWidget extends ConsumerWidget {
  const BudgetOverviewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetsAsync = ref.watch(activeBudgetsProvider);

    return budgetsAsync.when(
      data: (budgets) {
        if (budgets.isEmpty) {
          return Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Active Budgets',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create a budget to track your spending and stay on top of your finances.',
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Navigate to add budget page
                      // TODO: Implement navigation
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Create Budget'),
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Budget Overview',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      // Navigate to budgets page
                      // TODO: Implement navigation
                    },
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('View All'),
                  ),
                ],
              ),
            ),
            ...budgets.map(
              (budget) => BudgetProgressWidget(
                budget: budget,
                onTap: () {
                  // Navigate to budget details
                  // TODO: Implement navigation
                },
              ),
            ),
            if (budgets.length > 3)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextButton(
                  onPressed: () {
                    // Navigate to all budgets
                    // TODO: Implement navigation
                  },
                  child: const Text('View All Budgets'),
                ),
              ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Card(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
              const SizedBox(height: 16),
              Text(
                'Error Loading Budgets',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.red[600]),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.red[500]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

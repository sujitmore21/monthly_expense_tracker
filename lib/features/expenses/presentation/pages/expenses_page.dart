import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/expense_provider.dart';
import '../widgets/expense_list_item.dart';
import 'add_expense_page.dart';

class ExpensesPage extends ConsumerWidget {
  const ExpensesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(expensesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Show filter options
            },
          ),
        ],
      ),
      body: expensesAsync.when(
        data: (expenses) {
          if (expenses.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No expenses yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tap the + button to add your first expense',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // Group expenses by date
          final groupedExpenses = <String, List<dynamic>>{};
          for (final expense in expenses) {
            final dateKey = expense.date.toString().split(' ')[0];
            if (!groupedExpenses.containsKey(dateKey)) {
              groupedExpenses[dateKey] = [];
            }
            groupedExpenses[dateKey]!.add(expense);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: groupedExpenses.length,
            itemBuilder: (context, index) {
              final dateKey = groupedExpenses.keys.elementAt(index);
              final dayExpenses = groupedExpenses[dateKey]!;
              final total = dayExpenses.fold(
                0.0,
                (sum, expense) => sum + expense.amount,
              );

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            dateKey,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '₹${total.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                    ...dayExpenses.map(
                      (expense) => ExpenseListItem(
                        expense: expense,
                        onTap: () {
                          // Navigate to edit expense
                        },
                        onDelete: () {
                          ref
                              .read(expenseNotifierProvider.notifier)
                              .deleteExpense(expense.id);
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(expensesProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "expenses_fab",
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddExpensePage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'hive_service.dart';
import 'notification_service.dart';
import 'recurring_service.dart';
import 'budget_monitoring_service.dart';
import '../../features/expenses/data/repositories/expense_repository.dart';
import '../../features/expenses/data/repositories/category_repository.dart';
import '../../features/budgets/data/repositories/budget_repository.dart';
import '../../features/expenses/data/models/expense_model.dart';
import '../../features/budgets/data/models/budget_model.dart';
import 'package:uuid/uuid.dart';

class AppInitializationService {
  static Future<void> initializeApp() async {
    // Initialize Hive storage
    await HiveService.init();

    // Initialize notifications
    await NotificationService.initialize();

    // Add sample data if no expenses exist
    await _addSampleDataIfNeeded();

    // Process recurring transactions
    await _processRecurringTransactions();

    // Check budget warnings
    await _checkBudgetWarnings();
  }

  static Future<void> _processRecurringTransactions() async {
    try {
      final expenseRepository = ExpenseRepository();
      final categoryRepository = CategoryRepository();
      final recurringService = RecurringService(
        expenseRepository,
        categoryRepository,
      );

      await recurringService.processRecurringTransactions();
    } catch (e) {
      print('Error processing recurring transactions on app launch: $e');
    }
  }

  static Future<void> _checkBudgetWarnings() async {
    try {
      final budgetRepository = BudgetRepository();
      final budgetMonitoringService = BudgetMonitoringService(
        budgetRepository,
        NotificationService(),
      );

      // Update all budget spent amounts
      await budgetMonitoringService.updateAllBudgetSpent();

      // Check for warnings
      await budgetMonitoringService.checkBudgetWarnings();
    } catch (e) {
      print('Error checking budget warnings on app launch: $e');
    }
  }

  static Future<void> _addSampleDataIfNeeded() async {
    try {
      final expenseRepository = ExpenseRepository();
      final expenses = await expenseRepository.getAllExpenses();

      if (expenses.isEmpty) {
        final now = DateTime.now();
        final sampleExpenses = [
          ExpenseModel(
            id: const Uuid().v4(),
            title: 'Coffee Shop',
            amount: 4.50,
            categoryId: 'food',
            date: now.subtract(const Duration(days: 1)),
            description: 'Morning coffee',
          ),
          ExpenseModel(
            id: const Uuid().v4(),
            title: 'Gas Station',
            amount: 45.00,
            categoryId: 'transport',
            date: now.subtract(const Duration(days: 2)),
            description: 'Fuel for car',
          ),
          ExpenseModel(
            id: const Uuid().v4(),
            title: 'Grocery Store',
            amount: 85.50,
            categoryId: 'food',
            date: now.subtract(const Duration(days: 3)),
            description: 'Weekly groceries',
          ),
          ExpenseModel(
            id: const Uuid().v4(),
            title: 'Movie Theater',
            amount: 25.00,
            categoryId: 'entertainment',
            date: now.subtract(const Duration(days: 4)),
            description: 'Weekend movie',
          ),
          ExpenseModel(
            id: const Uuid().v4(),
            title: 'Electric Bill',
            amount: 120.00,
            categoryId: 'bills',
            date: now.subtract(const Duration(days: 5)),
            description: 'Monthly electricity bill',
          ),
        ];

        for (final expense in sampleExpenses) {
          await expenseRepository.addExpense(expense);
        }

        print('Added ${sampleExpenses.length} sample expenses');
      }

      // Add sample budgets if none exist
      final budgetRepository = BudgetRepository();
      final budgets = await budgetRepository.getAllBudgets();

      if (budgets.isEmpty) {
        final now = DateTime.now();
        final startOfMonth = DateTime(now.year, now.month, 1);
        final endOfMonth = DateTime(now.year, now.month + 1, 0);

        final sampleBudgets = [
          BudgetModel(
            id: const Uuid().v4(),
            name: 'Food & Dining',
            amount: 500.0,
            categoryId: 'food',
            startDate: startOfMonth,
            endDate: endOfMonth,
            spent: 90.0, // Based on sample expenses
            isActive: true,
          ),
          BudgetModel(
            id: const Uuid().v4(),
            name: 'Transportation',
            amount: 200.0,
            categoryId: 'transport',
            startDate: startOfMonth,
            endDate: endOfMonth,
            spent: 45.0, // Based on sample expenses
            isActive: true,
          ),
          BudgetModel(
            id: const Uuid().v4(),
            name: 'Entertainment',
            amount: 100.0,
            categoryId: 'entertainment',
            startDate: startOfMonth,
            endDate: endOfMonth,
            spent: 25.0, // Based on sample expenses
            isActive: true,
          ),
        ];

        for (final budget in sampleBudgets) {
          await budgetRepository.addBudget(budget);
        }

        print('Added ${sampleBudgets.length} sample budgets');
      }
    } catch (e) {
      print('Error adding sample data: $e');
    }
  }
}

// Provider for app initialization
final appInitializationProvider = Provider<AppInitializationService>((ref) {
  return AppInitializationService();
});

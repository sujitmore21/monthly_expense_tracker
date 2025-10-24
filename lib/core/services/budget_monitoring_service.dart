import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monthly_expense_tracker/features/budgets/presentation/providers/budget_provider.dart';
import '../../features/budgets/data/repositories/budget_repository.dart';
import '../../features/budgets/data/models/budget_model.dart';
import 'notification_service.dart';

class BudgetMonitoringService {
  final BudgetRepository _budgetRepository;
  final NotificationService _notificationService;

  BudgetMonitoringService(this._budgetRepository, this._notificationService);

  /// Check all active budgets for warnings and send notifications
  Future<void> checkBudgetWarnings() async {
    try {
      // Get budgets that are near or exceeding thresholds
      final nearThresholdBudgets = await _budgetRepository
          .getBudgetsNearThreshold();
      final exceededBudgets = await _budgetRepository
          .getBudgetsExceedingThreshold();

      // Send notifications for budgets near threshold
      for (final budget in nearThresholdBudgets) {
        await NotificationService.showBudgetWarningNotification(budget);
      }

      // Send notifications for exceeded budgets
      for (final budget in exceededBudgets) {
        await NotificationService.showBudgetWarningNotification(budget);
      }
    } catch (e) {
      // Log error but don't crash the app
      print('Error checking budget warnings: $e');
    }
  }

  /// Update spent amounts for all active budgets
  Future<void> updateAllBudgetSpent() async {
    try {
      final activeBudgets = await _budgetRepository.getActiveBudgets();

      for (final budget in activeBudgets) {
        await _budgetRepository.updateBudgetSpent(budget.id);
      }
    } catch (e) {
      print('Error updating budget spent amounts: $e');
    }
  }

  /// Get budget summary for dashboard
  Future<BudgetSummary> getBudgetSummary() async {
    try {
      final activeBudgets = await _budgetRepository.getActiveBudgets();
      final nearThreshold = await _budgetRepository.getBudgetsNearThreshold();
      final exceeded = await _budgetRepository.getBudgetsExceedingThreshold();

      double totalBudget = 0;
      double totalSpent = 0;
      int budgetsAtRisk = nearThreshold.length + exceeded.length;

      for (final budget in activeBudgets) {
        totalBudget += budget.amount;
        totalSpent += budget.spent;
      }

      return BudgetSummary(
        totalBudget: totalBudget,
        totalSpent: totalSpent,
        budgetsAtRisk: budgetsAtRisk,
        activeBudgetsCount: activeBudgets.length,
        averageSpentPercentage: totalBudget > 0 ? totalSpent / totalBudget : 0,
      );
    } catch (e) {
      print('Error getting budget summary: $e');
      return BudgetSummary.empty();
    }
  }
}

class BudgetSummary {
  final double totalBudget;
  final double totalSpent;
  final int budgetsAtRisk;
  final int activeBudgetsCount;
  final double averageSpentPercentage;

  const BudgetSummary({
    required this.totalBudget,
    required this.totalSpent,
    required this.budgetsAtRisk,
    required this.activeBudgetsCount,
    required this.averageSpentPercentage,
  });

  factory BudgetSummary.empty() {
    return const BudgetSummary(
      totalBudget: 0,
      totalSpent: 0,
      budgetsAtRisk: 0,
      activeBudgetsCount: 0,
      averageSpentPercentage: 0,
    );
  }

  double get remaining => totalBudget - totalSpent;
  double get spentPercentage => totalBudget > 0 ? totalSpent / totalBudget : 0;
  bool get isOverBudget => spentPercentage >= 1.0;
}

// Provider for the budget monitoring service
final budgetMonitoringServiceProvider = Provider<BudgetMonitoringService>((
  ref,
) {
  final budgetRepository = ref.read(budgetRepositoryProvider);
  return BudgetMonitoringService(budgetRepository, NotificationService());
});

// Provider for budget summary
final budgetSummaryProvider = FutureProvider<BudgetSummary>((ref) async {
  final service = ref.read(budgetMonitoringServiceProvider);
  return service.getBudgetSummary();
});

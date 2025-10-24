import '../models/budget_model.dart';
import '../../../../core/services/hive_service.dart';
import '../../../expenses/data/repositories/expense_repository.dart';

class BudgetRepository {
  final ExpenseRepository _expenseRepository = ExpenseRepository();

  Future<List<BudgetModel>> getAllBudgets() async {
    return HiveService.budgets.values.toList();
  }

  Future<List<BudgetModel>> getActiveBudgets() async {
    return HiveService.budgets.values
        .where((budget) => budget.isActive)
        .toList();
  }

  Future<List<BudgetModel>> getBudgetsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    return HiveService.budgets.values
        .where(
          (budget) =>
              budget.startDate.isBefore(end) && budget.endDate.isAfter(start),
        )
        .toList();
  }

  Future<BudgetModel?> getBudgetById(String id) async {
    return HiveService.budgets.get(id);
  }

  Future<void> addBudget(BudgetModel budget) async {
    await HiveService.budgets.put(budget.id, budget);
  }

  Future<void> updateBudget(BudgetModel budget) async {
    await HiveService.budgets.put(budget.id, budget);
  }

  Future<void> deleteBudget(String id) async {
    await HiveService.budgets.delete(id);
  }

  Future<BudgetModel> updateBudgetSpent(String budgetId) async {
    final budget = await getBudgetById(budgetId);
    if (budget == null) throw Exception('Budget not found');

    final spent = await _expenseRepository.getTotalExpensesByCategory(
      budget.categoryId,
      budget.startDate,
    );

    final updatedBudget = budget.copyWith(spent: spent);
    await updateBudget(updatedBudget);
    return updatedBudget;
  }

  Future<List<BudgetModel>> getBudgetsExceedingThreshold() async {
    final budgets = await getActiveBudgets();
    final exceededBudgets = <BudgetModel>[];

    for (final budget in budgets) {
      final spentPercentage = budget.spent / budget.amount;
      if (spentPercentage >= budget.dangerThreshold) {
        exceededBudgets.add(budget);
      }
    }

    return exceededBudgets;
  }

  Future<List<BudgetModel>> getBudgetsNearThreshold() async {
    final budgets = await getActiveBudgets();
    final nearThresholdBudgets = <BudgetModel>[];

    for (final budget in budgets) {
      final spentPercentage = budget.spent / budget.amount;
      if (spentPercentage >= budget.warningThreshold &&
          spentPercentage < budget.dangerThreshold) {
        nearThresholdBudgets.add(budget);
      }
    }

    return nearThresholdBudgets;
  }
}

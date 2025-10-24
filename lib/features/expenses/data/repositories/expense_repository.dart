import '../models/expense_model.dart';
import '../../../../core/services/hive_service.dart';

class ExpenseRepository {
  Future<List<ExpenseModel>> getAllExpenses() async {
    return HiveService.expenses.values.toList();
  }

  Future<List<ExpenseModel>> getExpensesByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    return HiveService.expenses.values
        .where(
          (expense) =>
              expense.date.isAfter(start.subtract(const Duration(days: 1))) &&
              expense.date.isBefore(end.add(const Duration(days: 1))),
        )
        .toList();
  }

  Future<List<ExpenseModel>> getExpensesByCategory(String categoryId) async {
    return HiveService.expenses.values
        .where((expense) => expense.categoryId == categoryId)
        .toList();
  }

  Future<List<ExpenseModel>> getExpensesByMonth(DateTime month) async {
    final startOfMonth = DateTime(month.year, month.month, 1);
    final endOfMonth = DateTime(month.year, month.month + 1, 0);
    return getExpensesByDateRange(startOfMonth, endOfMonth);
  }

  Future<ExpenseModel?> getExpenseById(String id) async {
    return HiveService.expenses.get(id);
  }

  Future<void> addExpense(ExpenseModel expense) async {
    await HiveService.expenses.put(expense.id, expense);
  }

  Future<void> updateExpense(ExpenseModel expense) async {
    await HiveService.expenses.put(expense.id, expense);
  }

  Future<void> deleteExpense(String id) async {
    await HiveService.expenses.delete(id);
  }

  Future<double> getTotalExpensesByMonth(DateTime month) async {
    final expenses = await getExpensesByMonth(month);
    double total = 0.0;
    for (final expense in expenses) {
      total += expense.amount;
    }
    return total;
  }

  Future<double> getTotalExpensesByCategory(
    String categoryId,
    DateTime month,
  ) async {
    final expenses = await getExpensesByMonth(month);
    double total = 0.0;
    for (final expense in expenses) {
      if (expense.categoryId == categoryId) {
        total += expense.amount;
      }
    }
    return total;
  }
}

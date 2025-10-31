import '../models/expense_model.dart';
import '../../../../core/services/hive_service.dart';

class ExpenseRepository {
  Future<List<ExpenseModel>> getAllExpenses() async {
    final result = HiveService.expenses.values.toList();
    print('getAllExpenses: found ${result.length} total expenses');
    return result;
  }

  Future<List<ExpenseModel>> getExpensesByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final allExpenses = HiveService.expenses.values.toList();
    print(
      'getExpensesByDateRange: total expenses in Hive = ${allExpenses.length}',
    );

    final result = allExpenses.where((expense) {
      final expenseDate = expense.date;
      // Normalize dates to midnight for comparison
      final normalizedExpense = DateTime(
        expenseDate.year,
        expenseDate.month,
        expenseDate.day,
      );
      final normalizedStart = DateTime(start.year, start.month, start.day);
      final normalizedEnd = DateTime(end.year, end.month, end.day);

      final isInRange =
          normalizedExpense.isAtSameMomentAs(normalizedStart) ||
          normalizedExpense.isAtSameMomentAs(normalizedEnd) ||
          (normalizedExpense.isAfter(normalizedStart) &&
              normalizedExpense.isBefore(normalizedEnd));

      if (isInRange) {
        print(
          '  Found expense: ${expense.title} - ${expense.amount} on ${normalizedExpense}',
        );
      }

      return isInRange;
    }).toList();

    print('getExpensesByDateRange: found ${result.length} expenses in range');
    return result;
  }

  Future<List<ExpenseModel>> getExpensesByCategory(String categoryId) async {
    return HiveService.expenses.values
        .where((expense) => expense.categoryId == categoryId)
        .toList();
  }

  Future<List<ExpenseModel>> getExpensesByMonth(DateTime month) async {
    final startOfMonth = DateTime(month.year, month.month, 1);
    final endOfMonth = DateTime(month.year, month.month + 1, 0);
    print(
      'getExpensesByMonth: month=$month, startOfMonth=$startOfMonth, endOfMonth=$endOfMonth',
    );
    final result = await getExpensesByDateRange(startOfMonth, endOfMonth);
    print('getExpensesByMonth: found ${result.length} expenses');
    return result;
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

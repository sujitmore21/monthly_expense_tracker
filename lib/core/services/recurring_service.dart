import 'package:uuid/uuid.dart';
import '../../features/expenses/data/models/expense_model.dart';
import '../../features/expenses/data/models/recurring_transaction_model.dart';
import '../../features/expenses/data/repositories/expense_repository.dart';
import '../../features/expenses/data/repositories/category_repository.dart';
import '../../core/services/hive_service.dart';

class RecurringService {
  final ExpenseRepository _expenseRepository;
  final CategoryRepository _categoryRepository;
  final Uuid _uuid = const Uuid();

  RecurringService(this._expenseRepository, this._categoryRepository);

  /// Process all active recurring transactions and create expense instances for missed periods
  Future<void> processRecurringTransactions() async {
    try {
      final recurringTransactions = await _getActiveRecurringTransactions();

      for (final recurring in recurringTransactions) {
        await _processRecurringTransaction(recurring);
      }
    } catch (e) {
      print('Error processing recurring transactions: $e');
    }
  }

  /// Get all active recurring transactions
  Future<List<RecurringTransactionModel>>
  _getActiveRecurringTransactions() async {
    return HiveService.recurring.values
        .where((recurring) => recurring.isActive)
        .toList();
  }

  /// Process a single recurring transaction
  Future<void> _processRecurringTransaction(
    RecurringTransactionModel recurring,
  ) async {
    final now = DateTime.now();
    final lastProcessedDate = await _getLastProcessedDate(recurring.id);

    // Calculate the next occurrence date
    final nextOccurrence = _calculateNextOccurrence(
      recurring,
      lastProcessedDate ?? recurring.startDate,
    );

    // If the next occurrence is in the past or today, create the expense
    if (nextOccurrence.isBefore(now) || _isSameDay(nextOccurrence, now)) {
      await _createExpenseFromRecurring(recurring, nextOccurrence);
      await _updateLastProcessedDate(recurring.id, nextOccurrence);
    }
  }

  /// Calculate the next occurrence date for a recurring transaction
  DateTime _calculateNextOccurrence(
    RecurringTransactionModel recurring,
    DateTime lastDate,
  ) {
    switch (recurring.recurrenceType) {
      case RecurrenceType.daily:
        return lastDate.add(const Duration(days: 1));

      case RecurrenceType.weekly:
        return lastDate.add(const Duration(days: 7));

      case RecurrenceType.monthly:
        return DateTime(
          lastDate.year,
          lastDate.month + 1,
          recurring.dayOfMonth ?? lastDate.day,
        );

      case RecurrenceType.yearly:
        return DateTime(lastDate.year + 1, lastDate.month, lastDate.day);
    }
  }

  /// Create an expense from a recurring transaction
  Future<void> _createExpenseFromRecurring(
    RecurringTransactionModel recurring,
    DateTime occurrenceDate,
  ) async {
    // Check if expense already exists for this date
    final existingExpense = await _findExistingExpense(
      recurring,
      occurrenceDate,
    );
    if (existingExpense != null) return;

    // Create new expense
    final expense = ExpenseModel(
      id: _uuid.v4(),
      title: recurring.title,
      amount: recurring.amount,
      categoryId: recurring.categoryId,
      date: occurrenceDate,
      description: recurring.description,
      tags: recurring.tags,
      isRecurring: true,
      recurringId: recurring.id,
    );

    await _expenseRepository.addExpense(expense);
  }

  /// Find existing expense for a recurring transaction on a specific date
  Future<ExpenseModel?> _findExistingExpense(
    RecurringTransactionModel recurring,
    DateTime date,
  ) async {
    final expenses = await _expenseRepository.getExpensesByDateRange(
      date,
      date.add(const Duration(days: 1)),
    );

    return expenses.firstWhere(
      (expense) =>
          expense.recurringId == recurring.id && _isSameDay(expense.date, date),
      orElse: () => throw StateError('No matching element'),
    );
  }

  /// Check if two dates are the same day
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Get the last processed date for a recurring transaction
  Future<DateTime?> _getLastProcessedDate(String recurringId) async {
    // This would typically be stored in a separate table or field
    // For now, we'll use the last expense date for this recurring transaction
    final expenses = await _expenseRepository.getAllExpenses();
    final recurringExpenses = expenses
        .where((expense) => expense.recurringId == recurringId)
        .toList();

    if (recurringExpenses.isEmpty) return null;

    recurringExpenses.sort((a, b) => b.date.compareTo(a.date));
    return recurringExpenses.first.date;
  }

  /// Update the last processed date for a recurring transaction
  Future<void> _updateLastProcessedDate(
    String recurringId,
    DateTime date,
  ) async {
    // This would typically be stored in a separate table or field
    // For now, we'll use the expense date as the last processed date
    // In a real implementation, you might want to store this separately
  }

  /// Create a new recurring transaction
  Future<void> createRecurringTransaction(
    RecurringTransactionModel recurring,
  ) async {
    await HiveService.recurring.put(recurring.id, recurring);
  }

  /// Update a recurring transaction
  Future<void> updateRecurringTransaction(
    RecurringTransactionModel recurring,
  ) async {
    await HiveService.recurring.put(recurring.id, recurring);
  }

  /// Delete a recurring transaction
  Future<void> deleteRecurringTransaction(String id) async {
    await HiveService.recurring.delete(id);
  }

  /// Get all recurring transactions
  Future<List<RecurringTransactionModel>> getAllRecurringTransactions() async {
    return HiveService.recurring.values.toList();
  }

  /// Get active recurring transactions
  Future<List<RecurringTransactionModel>>
  getActiveRecurringTransactions() async {
    return HiveService.recurring.values
        .where((recurring) => recurring.isActive)
        .toList();
  }

  /// Get recurring transactions by category
  Future<List<RecurringTransactionModel>> getRecurringTransactionsByCategory(
    String categoryId,
  ) async {
    return HiveService.recurring.values
        .where((recurring) => recurring.categoryId == categoryId)
        .toList();
  }

  /// Pause a recurring transaction
  Future<void> pauseRecurringTransaction(String id) async {
    final recurring = await HiveService.recurring.get(id);
    if (recurring != null) {
      final updated = recurring.copyWith(isActive: false);
      await HiveService.recurring.put(id, updated);
    }
  }

  /// Resume a recurring transaction
  Future<void> resumeRecurringTransaction(String id) async {
    final recurring = await HiveService.recurring.get(id);
    if (recurring != null) {
      final updated = recurring.copyWith(isActive: true);
      await HiveService.recurring.put(id, updated);
    }
  }
}

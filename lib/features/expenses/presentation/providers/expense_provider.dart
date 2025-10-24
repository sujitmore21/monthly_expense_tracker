import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/expense_model.dart';
import '../../data/repositories/expense_repository.dart';

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  return ExpenseRepository();
});

final expensesProvider = FutureProvider<List<ExpenseModel>>((ref) async {
  final repository = ref.read(expenseRepositoryProvider);
  return repository.getAllExpenses();
});

final monthlyExpensesProvider =
    FutureProvider.family<List<ExpenseModel>, DateTime>((ref, month) async {
      final repository = ref.read(expenseRepositoryProvider);
      return repository.getExpensesByMonth(month);
    });

final expensesByCategoryProvider =
    FutureProvider.family<List<ExpenseModel>, String>((ref, categoryId) async {
      final repository = ref.read(expenseRepositoryProvider);
      return repository.getExpensesByCategory(categoryId);
    });

final totalMonthlyExpensesProvider = FutureProvider.family<double, DateTime>((
  ref,
  month,
) async {
  final repository = ref.read(expenseRepositoryProvider);
  return repository.getTotalExpensesByMonth(month);
});

class ExpenseNotifier extends StateNotifier<AsyncValue<List<ExpenseModel>>> {
  ExpenseNotifier(this._repository) : super(const AsyncValue.loading());

  final ExpenseRepository _repository;

  Future<void> loadExpenses() async {
    state = const AsyncValue.loading();
    try {
      final expenses = await _repository.getAllExpenses();
      state = AsyncValue.data(expenses);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addExpense(ExpenseModel expense) async {
    try {
      await _repository.addExpense(expense);
      await loadExpenses();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateExpense(ExpenseModel expense) async {
    try {
      await _repository.updateExpense(expense);
      await loadExpenses();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteExpense(String id) async {
    try {
      await _repository.deleteExpense(id);
      await loadExpenses();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

final expenseNotifierProvider =
    StateNotifierProvider<ExpenseNotifier, AsyncValue<List<ExpenseModel>>>((
      ref,
    ) {
      final repository = ref.read(expenseRepositoryProvider);
      return ExpenseNotifier(repository);
    });

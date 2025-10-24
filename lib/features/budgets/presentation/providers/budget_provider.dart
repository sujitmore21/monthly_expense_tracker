import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/budget_model.dart';
import '../../data/repositories/budget_repository.dart';

final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  return BudgetRepository();
});

final budgetsProvider = FutureProvider<List<BudgetModel>>((ref) async {
  final repository = ref.read(budgetRepositoryProvider);
  return repository.getAllBudgets();
});

final activeBudgetsProvider = FutureProvider<List<BudgetModel>>((ref) async {
  final repository = ref.read(budgetRepositoryProvider);
  return repository.getActiveBudgets();
});

final budgetsExceedingThresholdProvider = FutureProvider<List<BudgetModel>>((
  ref,
) async {
  final repository = ref.read(budgetRepositoryProvider);
  return repository.getBudgetsExceedingThreshold();
});

final budgetsNearThresholdProvider = FutureProvider<List<BudgetModel>>((
  ref,
) async {
  final repository = ref.read(budgetRepositoryProvider);
  return repository.getBudgetsNearThreshold();
});

class BudgetNotifier extends StateNotifier<AsyncValue<List<BudgetModel>>> {
  BudgetNotifier(this._repository) : super(const AsyncValue.loading());

  final BudgetRepository _repository;

  Future<void> loadBudgets() async {
    state = const AsyncValue.loading();
    try {
      final budgets = await _repository.getAllBudgets();
      state = AsyncValue.data(budgets);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addBudget(BudgetModel budget) async {
    try {
      await _repository.addBudget(budget);
      await loadBudgets();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateBudget(BudgetModel budget) async {
    try {
      await _repository.updateBudget(budget);
      await loadBudgets();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteBudget(String id) async {
    try {
      await _repository.deleteBudget(id);
      await loadBudgets();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateBudgetSpent(String budgetId) async {
    try {
      await _repository.updateBudgetSpent(budgetId);
      await loadBudgets();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

final budgetNotifierProvider =
    StateNotifierProvider<BudgetNotifier, AsyncValue<List<BudgetModel>>>((ref) {
      final repository = ref.read(budgetRepositoryProvider);
      return BudgetNotifier(repository);
    });

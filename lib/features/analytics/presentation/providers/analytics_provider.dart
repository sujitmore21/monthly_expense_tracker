import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../expenses/data/repositories/expense_repository.dart';
import '../../../expenses/data/repositories/category_repository.dart';
import '../../../expenses/data/models/category_model.dart';

final analyticsRepositoryProvider = Provider<ExpenseRepository>((ref) {
  return ExpenseRepository();
});

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepository();
});

final monthlyExpensesProvider = FutureProvider.family<List<dynamic>, DateTime>((
  ref,
  month,
) async {
  final repository = ref.read(analyticsRepositoryProvider);
  return repository.getExpensesByMonth(month);
});

final totalMonthlyExpensesProvider = FutureProvider.family<double, DateTime>((
  ref,
  month,
) async {
  final repository = ref.read(analyticsRepositoryProvider);
  return repository.getTotalExpensesByMonth(month);
});

final expensesByCategoryProvider =
    FutureProvider.family<Map<String, double>, DateTime>((ref, month) async {
      final expenseRepository = ref.read(analyticsRepositoryProvider);
      final categoryRepository = ref.read(categoryRepositoryProvider);

      final expenses = await expenseRepository.getExpensesByMonth(month);
      final categories = await categoryRepository.getAllCategories();

      final categoryTotals = <String, double>{};

      for (final expense in expenses) {
        final category = categories.firstWhere(
          (cat) => cat.id == expense.categoryId,
          orElse: () => const CategoryModel(
            id: 'unknown',
            name: 'Unknown',
            icon: '❓',
            color: 0xFF9E9E9E,
          ),
        );

        categoryTotals[category.name] =
            (categoryTotals[category.name] ?? 0) + expense.amount;
      }

      return categoryTotals;
    });

final dailyExpensesProvider =
    FutureProvider.family<Map<String, double>, DateTime>((ref, month) async {
      final repository = ref.read(analyticsRepositoryProvider);
      final expenses = await repository.getExpensesByMonth(month);

      final dailyTotals = <String, double>{};

      for (final expense in expenses) {
        final dateKey = expense.date.toString().split(' ')[0];
        dailyTotals[dateKey] = (dailyTotals[dateKey] ?? 0) + expense.amount;
      }

      return dailyTotals;
    });

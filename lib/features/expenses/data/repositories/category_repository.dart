import '../models/category_model.dart';
import '../../../../core/services/hive_service.dart';

class CategoryRepository {
  Future<List<CategoryModel>> getAllCategories() async {
    return HiveService.categories.values.toList();
  }

  Future<List<CategoryModel>> getExpenseCategories() async {
    return HiveService.categories.values
        .where((category) => !category.isIncome)
        .toList();
  }

  Future<List<CategoryModel>> getIncomeCategories() async {
    return HiveService.categories.values
        .where((category) => category.isIncome)
        .toList();
  }

  Future<CategoryModel?> getCategoryById(String id) async {
    return HiveService.categories.get(id);
  }

  Future<void> addCategory(CategoryModel category) async {
    await HiveService.categories.put(category.id, category);
  }

  Future<void> updateCategory(CategoryModel category) async {
    await HiveService.categories.put(category.id, category);
  }

  Future<void> deleteCategory(String id) async {
    await HiveService.categories.delete(id);
  }

  Future<bool> canDeleteCategory(String id) async {
    // Check if any expenses use this category
    final expenses = HiveService.expenses.values
        .where((expense) => expense.categoryId == id)
        .toList();
    return expenses.isEmpty;
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/category_model.dart';
import '../../data/repositories/category_repository.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepository();
});

final categoriesProvider = FutureProvider<List<CategoryModel>>((ref) async {
  final repository = ref.read(categoryRepositoryProvider);
  return repository.getAllCategories();
});

final expenseCategoriesProvider = FutureProvider<List<CategoryModel>>((
  ref,
) async {
  final repository = ref.read(categoryRepositoryProvider);
  return repository.getExpenseCategories();
});

final incomeCategoriesProvider = FutureProvider<List<CategoryModel>>((
  ref,
) async {
  final repository = ref.read(categoryRepositoryProvider);
  return repository.getIncomeCategories();
});

class CategoryNotifier extends StateNotifier<AsyncValue<List<CategoryModel>>> {
  CategoryNotifier(this._repository) : super(const AsyncValue.loading());

  final CategoryRepository _repository;

  Future<void> loadCategories() async {
    state = const AsyncValue.loading();
    try {
      final categories = await _repository.getAllCategories();
      state = AsyncValue.data(categories);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addCategory(CategoryModel category) async {
    try {
      await _repository.addCategory(category);
      await loadCategories();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateCategory(CategoryModel category) async {
    try {
      await _repository.updateCategory(category);
      await loadCategories();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      final canDelete = await _repository.canDeleteCategory(id);
      if (!canDelete) {
        throw Exception('Cannot delete category that has associated expenses');
      }
      await _repository.deleteCategory(id);
      await loadCategories();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

final categoryNotifierProvider =
    StateNotifierProvider<CategoryNotifier, AsyncValue<List<CategoryModel>>>((
      ref,
    ) {
      final repository = ref.read(categoryRepositoryProvider);
      return CategoryNotifier(repository);
    });

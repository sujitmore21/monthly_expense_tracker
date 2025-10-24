import 'package:hive_flutter/hive_flutter.dart';
import '../../features/expenses/data/models/expense_model.dart';
import '../../features/expenses/data/models/category_model.dart';
import '../../features/budgets/data/models/budget_model.dart';
import '../../features/expenses/data/models/recurring_transaction_model.dart';

class HiveService {
  static const String expensesBox = 'expenses';
  static const String categoriesBox = 'categories';
  static const String budgetsBox = 'budgets';
  static const String recurringBox = 'recurring';

  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(ExpenseModelAdapter());
    Hive.registerAdapter(CategoryModelAdapter());
    Hive.registerAdapter(BudgetModelAdapter());
    Hive.registerAdapter(RecurringTransactionModelAdapter());

    // Open boxes
    await Hive.openBox<ExpenseModel>(expensesBox);
    await Hive.openBox<CategoryModel>(categoriesBox);
    await Hive.openBox<BudgetModel>(budgetsBox);
    await Hive.openBox<RecurringTransactionModel>(recurringBox);

    // Initialize default categories if empty
    await _initializeDefaultCategories();
  }

  static Future<void> _initializeDefaultCategories() async {
    final categoriesBox = Hive.box<CategoryModel>('categories');

    if (categoriesBox.isEmpty) {
      final defaultCategories = [
        const CategoryModel(
          id: 'food',
          name: 'Food & Dining',
          icon: '🍽️',
          color: 0xFFE57373,
          isDefault: true,
        ),
        const CategoryModel(
          id: 'transport',
          name: 'Transportation',
          icon: '🚗',
          color: 0xFF64B5F6,
          isDefault: true,
        ),
        const CategoryModel(
          id: 'shopping',
          name: 'Shopping',
          icon: '🛍️',
          color: 0xFF81C784,
          isDefault: true,
        ),
        const CategoryModel(
          id: 'entertainment',
          name: 'Entertainment',
          icon: '🎬',
          color: 0xFFFFB74D,
          isDefault: true,
        ),
        const CategoryModel(
          id: 'bills',
          name: 'Bills & Utilities',
          icon: '💡',
          color: 0xFFBA68C8,
          isDefault: true,
        ),
        const CategoryModel(
          id: 'healthcare',
          name: 'Healthcare',
          icon: '🏥',
          color: 0xFF4DB6AC,
          isDefault: true,
        ),
        const CategoryModel(
          id: 'income',
          name: 'Income',
          icon: '💰',
          color: 0xFF4CAF50,
          isDefault: true,
          isIncome: true,
        ),
      ];

      for (final category in defaultCategories) {
        await categoriesBox.put(category.id, category);
      }
    }
  }

  static Box<ExpenseModel> get expenses => Hive.box<ExpenseModel>(expensesBox);
  static Box<CategoryModel> get categories =>
      Hive.box<CategoryModel>(categoriesBox);
  static Box<BudgetModel> get budgets => Hive.box<BudgetModel>(budgetsBox);
  static Box<RecurringTransactionModel> get recurring =>
      Hive.box<RecurringTransactionModel>(recurringBox);

  static Future<void> close() async {
    await Hive.close();
  }
}

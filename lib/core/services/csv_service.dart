import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import '../../features/expenses/data/models/expense_model.dart';
import '../../features/expenses/data/models/category_model.dart';
import '../../features/budgets/data/models/budget_model.dart';
import '../../features/expenses/data/models/recurring_transaction_model.dart';

class CsvService {
  static final DateFormat _dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

  /// Export expenses to CSV file
  static Future<String> exportExpensesToCsv(List<ExpenseModel> expenses) async {
    final List<List<dynamic>> csvData = [
      [
        'ID',
        'Title',
        'Amount',
        'Category ID',
        'Date',
        'Description',
        'Location',
        'Tags',
        'Is Recurring',
        'Recurring ID',
      ],
    ];

    for (final expense in expenses) {
      csvData.add([
        expense.id,
        expense.title,
        expense.amount,
        expense.categoryId,
        _dateFormat.format(expense.date),
        expense.description ?? '',
        expense.location ?? '',
        expense.tags.join(';'),
        expense.isRecurring,
        expense.recurringId ?? '',
      ]);
    }

    final csvString = const ListToCsvConverter().convert(csvData);
    return await _saveCsvToFile(csvString, 'expenses_export.csv');
  }

  /// Export categories to CSV file
  static Future<String> exportCategoriesToCsv(
    List<CategoryModel> categories,
  ) async {
    final List<List<dynamic>> csvData = [
      ['ID', 'Name', 'Icon', 'Color', 'Is Default', 'Is Income'],
    ];

    for (final category in categories) {
      csvData.add([
        category.id,
        category.name,
        category.icon,
        category.color,
        category.isDefault,
        category.isIncome,
      ]);
    }

    final csvString = const ListToCsvConverter().convert(csvData);
    return await _saveCsvToFile(csvString, 'categories_export.csv');
  }

  /// Export budgets to CSV file
  static Future<String> exportBudgetsToCsv(List<BudgetModel> budgets) async {
    final List<List<dynamic>> csvData = [
      [
        'ID',
        'Name',
        'Amount',
        'Category ID',
        'Start Date',
        'End Date',
        'Spent',
        'Is Active',
        'Warning Threshold',
        'Danger Threshold',
      ],
    ];

    for (final budget in budgets) {
      csvData.add([
        budget.id,
        budget.name,
        budget.amount,
        budget.categoryId,
        _dateFormat.format(budget.startDate),
        _dateFormat.format(budget.endDate),
        budget.spent,
        budget.isActive,
        budget.warningThreshold,
        budget.dangerThreshold,
      ]);
    }

    final csvString = const ListToCsvConverter().convert(csvData);
    return await _saveCsvToFile(csvString, 'budgets_export.csv');
  }

  /// Export recurring transactions to CSV file
  static Future<String> exportRecurringTransactionsToCsv(
    List<RecurringTransactionModel> recurringTransactions,
  ) async {
    final List<List<dynamic>> csvData = [
      [
        'ID',
        'Title',
        'Amount',
        'Category ID',
        'Recurrence Type',
        'Start Date',
        'End Date',
        'Description',
        'Tags',
        'Is Active',
        'Day Of Month',
        'Day Of Week',
      ],
    ];

    for (final recurring in recurringTransactions) {
      csvData.add([
        recurring.id,
        recurring.title,
        recurring.amount,
        recurring.categoryId,
        recurring.recurrenceType.name,
        _dateFormat.format(recurring.startDate),
        recurring.endDate != null ? _dateFormat.format(recurring.endDate!) : '',
        recurring.description ?? '',
        recurring.tags.join(';'),
        recurring.isActive,
        recurring.dayOfMonth ?? '',
        recurring.dayOfWeek ?? '',
      ]);
    }

    final csvString = const ListToCsvConverter().convert(csvData);
    return await _saveCsvToFile(csvString, 'recurring_transactions_export.csv');
  }

  /// Export all data to CSV files
  static Future<List<String>> exportAllDataToCsv({
    required List<ExpenseModel> expenses,
    required List<CategoryModel> categories,
    required List<BudgetModel> budgets,
    required List<RecurringTransactionModel> recurringTransactions,
  }) async {
    final List<String> filePaths = [];

    // Export expenses
    final expensesPath = await exportExpensesToCsv(expenses);
    filePaths.add(expensesPath);

    // Export categories
    final categoriesPath = await exportCategoriesToCsv(categories);
    filePaths.add(categoriesPath);

    // Export budgets
    final budgetsPath = await exportBudgetsToCsv(budgets);
    filePaths.add(budgetsPath);

    // Export recurring transactions
    final recurringPath = await exportRecurringTransactionsToCsv(
      recurringTransactions,
    );
    filePaths.add(recurringPath);

    return filePaths;
  }

  /// Import expenses from CSV file
  static Future<List<ExpenseModel>> importExpensesFromCsv(
    String filePath,
  ) async {
    final file = File(filePath);
    final csvString = await file.readAsString();
    final csvData = const CsvToListConverter().convert(csvString);

    final List<ExpenseModel> expenses = [];

    // Skip header row
    for (int i = 1; i < csvData.length; i++) {
      final row = csvData[i];
      if (row.length >= 10) {
        try {
          final expense = ExpenseModel(
            id: row[0].toString(),
            title: row[1].toString(),
            amount: double.tryParse(row[2].toString()) ?? 0.0,
            categoryId: row[3].toString(),
            date: _dateFormat.parse(row[4].toString()),
            description: row[5].toString().isEmpty ? null : row[5].toString(),
            location: row[6].toString().isEmpty ? null : row[6].toString(),
            tags: row[7].toString().isEmpty ? [] : row[7].toString().split(';'),
            isRecurring: row[8].toString().toLowerCase() == 'true',
            recurringId: row[9].toString().isEmpty ? null : row[9].toString(),
          );
          expenses.add(expense);
        } catch (e) {
          print('Error parsing expense row $i: $e');
        }
      }
    }

    return expenses;
  }

  /// Import categories from CSV file
  static Future<List<CategoryModel>> importCategoriesFromCsv(
    String filePath,
  ) async {
    final file = File(filePath);
    final csvString = await file.readAsString();
    final csvData = const CsvToListConverter().convert(csvString);

    final List<CategoryModel> categories = [];

    // Skip header row
    for (int i = 1; i < csvData.length; i++) {
      final row = csvData[i];
      if (row.length >= 6) {
        try {
          final category = CategoryModel(
            id: row[0].toString(),
            name: row[1].toString(),
            icon: row[2].toString(),
            color: int.tryParse(row[3].toString()) ?? 0xFF000000,
            isDefault: row[4].toString().toLowerCase() == 'true',
            isIncome: row[5].toString().toLowerCase() == 'true',
          );
          categories.add(category);
        } catch (e) {
          print('Error parsing category row $i: $e');
        }
      }
    }

    return categories;
  }

  /// Import budgets from CSV file
  static Future<List<BudgetModel>> importBudgetsFromCsv(String filePath) async {
    final file = File(filePath);
    final csvString = await file.readAsString();
    final csvData = const CsvToListConverter().convert(csvString);

    final List<BudgetModel> budgets = [];

    // Skip header row
    for (int i = 1; i < csvData.length; i++) {
      final row = csvData[i];
      if (row.length >= 10) {
        try {
          final budget = BudgetModel(
            id: row[0].toString(),
            name: row[1].toString(),
            amount: double.tryParse(row[2].toString()) ?? 0.0,
            categoryId: row[3].toString(),
            startDate: _dateFormat.parse(row[4].toString()),
            endDate: _dateFormat.parse(row[5].toString()),
            spent: double.tryParse(row[6].toString()) ?? 0.0,
            isActive: row[7].toString().toLowerCase() == 'true',
            warningThreshold: double.tryParse(row[8].toString()) ?? 0.8,
            dangerThreshold: double.tryParse(row[9].toString()) ?? 1.0,
          );
          budgets.add(budget);
        } catch (e) {
          print('Error parsing budget row $i: $e');
        }
      }
    }

    return budgets;
  }

  /// Share CSV file
  static Future<void> shareCsvFile(String filePath, String fileName) async {
    await Share.shareXFiles([
      XFile(filePath),
    ], text: 'Expense Tracker Export: $fileName');
  }

  /// Pick CSV file for import
  static Future<String?> pickCsvFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null && result.files.single.path != null) {
      return result.files.single.path;
    }
    return null;
  }

  /// Save CSV string to file
  static Future<String> _saveCsvToFile(
    String csvString,
    String fileName,
  ) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsString(csvString);
    return file.path;
  }
}

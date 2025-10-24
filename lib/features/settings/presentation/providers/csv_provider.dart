import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import '../../../expenses/data/models/expense_model.dart';
import '../../../expenses/data/models/category_model.dart';
import '../../../expenses/data/repositories/expense_repository.dart';
import '../../../expenses/data/repositories/category_repository.dart';

class CsvService {
  final ExpenseRepository _expenseRepository;
  final CategoryRepository _categoryRepository;

  CsvService(this._expenseRepository, this._categoryRepository);

  Future<String> exportExpensesToCsv() async {
    final expenses = await _expenseRepository.getAllExpenses();
    final categories = await _categoryRepository.getAllCategories();

    // Create category lookup map
    final categoryMap = {for (var cat in categories) cat.id: cat.name};

    // Prepare CSV data
    final csvData = [
      [
        'Date',
        'Title',
        'Amount',
        'Category',
        'Description',
        'Location',
        'Tags',
      ],
    ];

    for (final expense in expenses) {
      csvData.add([
        expense.date.toString().split(' ')[0],
        expense.title,
        expense.amount.toString(),
        categoryMap[expense.categoryId] ?? 'Unknown',
        expense.description ?? '',
        expense.location ?? '',
        expense.tags.join(', '),
      ]);
    }

    // Convert to CSV string
    final csvString = const ListToCsvConverter().convert(csvData);

    // Save to file
    final directory = await getApplicationDocumentsDirectory();
    final file = File(
      '${directory.path}/expenses_export_${DateTime.now().millisecondsSinceEpoch}.csv',
    );
    await file.writeAsString(csvString);

    return file.path;
  }

  Future<void> importExpensesFromCsv(String filePath) async {
    final file = File(filePath);
    final csvString = await file.readAsString();

    final csvData = const CsvToListConverter().convert(csvString);

    // Skip header row
    for (int i = 1; i < csvData.length; i++) {
      final row = csvData[i];
      if (row.length >= 4) {
        try {
          final expense = ExpenseModel(
            id: DateTime.now().millisecondsSinceEpoch.toString() + i.toString(),
            title: row[1]?.toString() ?? '',
            amount: double.tryParse(row[2]?.toString() ?? '0') ?? 0.0,
            categoryId: _findCategoryIdByName(row[3]?.toString() ?? ''),
            date: DateTime.tryParse(row[0]?.toString() ?? '') ?? DateTime.now(),
            description: row.length > 4 ? row[4]?.toString() : null,
            location: row.length > 5 ? row[5]?.toString() : null,
            tags: row.length > 6 ? (row[6]?.toString() ?? '').split(', ') : [],
          );

          await _expenseRepository.addExpense(expense);
        } catch (e) {
          // Skip invalid rows
          continue;
        }
      }
    }
  }

  String _findCategoryIdByName(String categoryName) {
    // This is a simplified lookup - in a real app, you'd want to handle this better
    const categoryMappings = {
      'Food & Dining': 'food',
      'Transportation': 'transport',
      'Shopping': 'shopping',
      'Entertainment': 'entertainment',
      'Bills & Utilities': 'bills',
      'Healthcare': 'healthcare',
      'Income': 'income',
    };

    return categoryMappings[categoryName] ?? 'food';
  }
}

final csvServiceProvider = Provider<CsvService>((ref) {
  final expenseRepository = ExpenseRepository();
  final categoryRepository = CategoryRepository();
  return CsvService(expenseRepository, categoryRepository);
});

class CsvNotifier extends StateNotifier<AsyncValue<String?>> {
  CsvNotifier(this._csvService) : super(const AsyncValue.data(null));

  final CsvService _csvService;

  Future<void> exportExpenses() async {
    state = const AsyncValue.loading();
    try {
      final filePath = await _csvService.exportExpensesToCsv();
      state = AsyncValue.data(filePath);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> importExpenses(String filePath) async {
    state = const AsyncValue.loading();
    try {
      await _csvService.importExpensesFromCsv(filePath);
      state = const AsyncValue.data('Import successful');
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

final csvNotifierProvider =
    StateNotifierProvider<CsvNotifier, AsyncValue<String?>>((ref) {
      final csvService = ref.read(csvServiceProvider);
      return CsvNotifier(csvService);
    });

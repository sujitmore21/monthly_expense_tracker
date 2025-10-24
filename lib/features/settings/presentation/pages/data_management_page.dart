import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/csv_service.dart';
import '../../../../features/expenses/data/repositories/expense_repository.dart';
import '../../../../features/expenses/data/repositories/category_repository.dart';
import '../../../../features/budgets/data/repositories/budget_repository.dart';
import '../../../../core/services/recurring_service.dart';
import '../../../../features/expenses/data/models/expense_model.dart';
import '../../../../features/expenses/data/models/category_model.dart';
import '../../../../features/budgets/data/models/budget_model.dart';
import '../../../../features/expenses/data/models/recurring_transaction_model.dart';

class DataManagementPage extends ConsumerStatefulWidget {
  const DataManagementPage({super.key});

  @override
  ConsumerState<DataManagementPage> createState() => _DataManagementPageState();
}

class _DataManagementPageState extends ConsumerState<DataManagementPage> {
  bool _isExporting = false;
  bool _isImporting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Management'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Export Data',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildExportSection(),
            const SizedBox(height: 32),
            Text(
              'Import Data',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildImportSection(),
            const SizedBox(height: 32),
            _buildBackupInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildExportSection() {
    return Column(
      children: [
        _buildExportButton(
          title: 'Export All Data',
          subtitle:
              'Export expenses, categories, budgets, and recurring transactions',
          icon: Icons.download,
          onPressed: _exportAllData,
        ),
        const SizedBox(height: 12),
        _buildExportButton(
          title: 'Export Expenses Only',
          subtitle: 'Export only expense transactions',
          icon: Icons.receipt,
          onPressed: _exportExpenses,
        ),
        const SizedBox(height: 12),
        _buildExportButton(
          title: 'Export Categories',
          subtitle: 'Export expense categories',
          icon: Icons.category,
          onPressed: _exportCategories,
        ),
        const SizedBox(height: 12),
        _buildExportButton(
          title: 'Export Budgets',
          subtitle: 'Export budget information',
          icon: Icons.account_balance_wallet,
          onPressed: _exportBudgets,
        ),
      ],
    );
  }

  Widget _buildImportSection() {
    return Column(
      children: [
        _buildImportButton(
          title: 'Import Expenses',
          subtitle: 'Import expenses from CSV file',
          icon: Icons.upload,
          onPressed: _importExpenses,
        ),
        const SizedBox(height: 12),
        _buildImportButton(
          title: 'Import Categories',
          subtitle: 'Import categories from CSV file',
          icon: Icons.category,
          onPressed: _importCategories,
        ),
        const SizedBox(height: 12),
        _buildImportButton(
          title: 'Import Budgets',
          subtitle: 'Import budgets from CSV file',
          icon: Icons.account_balance_wallet,
          onPressed: _importBudgets,
        ),
      ],
    );
  }

  Widget _buildExportButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: _isExporting
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.arrow_forward_ios),
        onTap: _isExporting ? null : onPressed,
      ),
    );
  }

  Widget _buildImportButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: _isImporting
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.arrow_forward_ios),
        onTap: _isImporting ? null : onPressed,
      ),
    );
  }

  Widget _buildBackupInfo() {
    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info, color: Colors.blue[700]),
                const SizedBox(width: 8),
                Text(
                  'Backup Information',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '• Export your data regularly to prevent data loss\n'
              '• CSV files can be opened in Excel, Google Sheets, or any spreadsheet app\n'
              '• Imported data will be added to your existing data\n'
              '• Keep backup files in a safe location',
              style: TextStyle(color: Colors.blue[600]),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportAllData() async {
    setState(() => _isExporting = true);

    try {
      final expenseRepository = ExpenseRepository();
      final categoryRepository = CategoryRepository();
      final budgetRepository = BudgetRepository();
      final recurringService = RecurringService(
        expenseRepository,
        categoryRepository,
      );

      final expenses = await expenseRepository.getAllExpenses();
      final categories = await categoryRepository.getAllCategories();
      final budgets = await budgetRepository.getAllBudgets();
      final recurringTransactions = await recurringService
          .getAllRecurringTransactions();

      final filePaths = await CsvService.exportAllDataToCsv(
        expenses: expenses,
        categories: categories,
        budgets: budgets,
        recurringTransactions: recurringTransactions,
      );

      // Share the first file (expenses) as the main export
      await CsvService.shareCsvFile(filePaths[0], 'expenses_export.csv');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All data exported successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error exporting data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isExporting = false);
    }
  }

  Future<void> _exportExpenses() async {
    setState(() => _isExporting = true);

    try {
      final expenseRepository = ExpenseRepository();
      final expenses = await expenseRepository.getAllExpenses();
      final filePath = await CsvService.exportExpensesToCsv(expenses);
      await CsvService.shareCsvFile(filePath, 'expenses_export.csv');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Expenses exported successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error exporting expenses: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isExporting = false);
    }
  }

  Future<void> _exportCategories() async {
    setState(() => _isExporting = true);

    try {
      final categoryRepository = CategoryRepository();
      final categories = await categoryRepository.getAllCategories();
      final filePath = await CsvService.exportCategoriesToCsv(categories);
      await CsvService.shareCsvFile(filePath, 'categories_export.csv');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Categories exported successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error exporting categories: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isExporting = false);
    }
  }

  Future<void> _exportBudgets() async {
    setState(() => _isExporting = true);

    try {
      final budgetRepository = BudgetRepository();
      final budgets = await budgetRepository.getAllBudgets();
      final filePath = await CsvService.exportBudgetsToCsv(budgets);
      await CsvService.shareCsvFile(filePath, 'budgets_export.csv');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Budgets exported successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error exporting budgets: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isExporting = false);
    }
  }

  Future<void> _importExpenses() async {
    setState(() => _isImporting = true);

    try {
      final filePath = await CsvService.pickCsvFile();
      if (filePath != null) {
        final expenses = await CsvService.importExpensesFromCsv(filePath);
        final expenseRepository = ExpenseRepository();

        for (final expense in expenses) {
          await expenseRepository.addExpense(expense);
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${expenses.length} expenses imported successfully!',
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error importing expenses: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isImporting = false);
    }
  }

  Future<void> _importCategories() async {
    setState(() => _isImporting = true);

    try {
      final filePath = await CsvService.pickCsvFile();
      if (filePath != null) {
        final categories = await CsvService.importCategoriesFromCsv(filePath);
        final categoryRepository = CategoryRepository();

        for (final category in categories) {
          await categoryRepository.addCategory(category);
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${categories.length} categories imported successfully!',
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error importing categories: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isImporting = false);
    }
  }

  Future<void> _importBudgets() async {
    setState(() => _isImporting = true);

    try {
      final filePath = await CsvService.pickCsvFile();
      if (filePath != null) {
        final budgets = await CsvService.importBudgetsFromCsv(filePath);
        final budgetRepository = BudgetRepository();

        for (final budget in budgets) {
          await budgetRepository.addBudget(budget);
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${budgets.length} budgets imported successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error importing budgets: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isImporting = false);
    }
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monthly_expense_tracker/features/expenses/presentation/providers/expense_provider.dart';
import 'exchange_rate_service.dart';
import '../../features/expenses/data/models/expense_model.dart';
import '../../features/expenses/data/repositories/expense_repository.dart';

class CurrencyConversionService {
  final ExpenseRepository _expenseRepository;
  final ExchangeRateService _exchangeRateService;

  CurrencyConversionService(this._expenseRepository, this._exchangeRateService);

  /// Convert all expenses to a target currency
  Future<List<ExpenseModel>> convertExpensesToCurrency(
    List<ExpenseModel> expenses,
    String targetCurrency,
  ) async {
    final List<ExpenseModel> convertedExpenses = [];

    for (final expense in expenses) {
      final expenseCurrency = expense.currency ?? 'USD';
      if (expenseCurrency == targetCurrency) {
        convertedExpenses.add(expense);
      } else {
        try {
          final convertedAmount = await ExchangeRateService.convertCurrency(
            expense.amount,
            expenseCurrency,
            targetCurrency,
          );

          convertedExpenses.add(
            expense.copyWith(amount: convertedAmount, currency: targetCurrency),
          );
        } catch (e) {
          print('Error converting expense ${expense.id}: $e');
          // Keep original expense if conversion fails
          convertedExpenses.add(expense);
        }
      }
    }

    return convertedExpenses;
  }

  /// Get total spending in a specific currency
  Future<double> getTotalSpendingInCurrency(
    List<ExpenseModel> expenses,
    String targetCurrency,
  ) async {
    double total = 0.0;

    for (final expense in expenses) {
      final expenseCurrency = expense.currency ?? 'USD';
      if (expenseCurrency == targetCurrency) {
        total += expense.amount;
      } else {
        try {
          final convertedAmount = await ExchangeRateService.convertCurrency(
            expense.amount,
            expenseCurrency,
            targetCurrency,
          );
          total += convertedAmount;
        } catch (e) {
          print('Error converting expense ${expense.id}: $e');
          // Skip this expense if conversion fails
        }
      }
    }

    return total;
  }

  /// Get spending breakdown by currency
  Future<Map<String, double>> getSpendingByCurrency(
    List<ExpenseModel> expenses,
  ) async {
    final Map<String, double> spendingByCurrency = {};

    for (final expense in expenses) {
      final expenseCurrency = expense.currency ?? 'USD';
      spendingByCurrency[expenseCurrency] =
          (spendingByCurrency[expenseCurrency] ?? 0) + expense.amount;
    }

    return spendingByCurrency;
  }

  /// Get currency statistics
  Future<CurrencyStats> getCurrencyStats(List<ExpenseModel> expenses) async {
    final spendingByCurrency = await getSpendingByCurrency(expenses);
    final totalCurrencies = spendingByCurrency.length;
    final mostUsedCurrency = spendingByCurrency.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;

    return CurrencyStats(
      totalCurrencies: totalCurrencies,
      mostUsedCurrency: mostUsedCurrency,
      spendingByCurrency: spendingByCurrency,
    );
  }
}

class CurrencyStats {
  final int totalCurrencies;
  final String mostUsedCurrency;
  final Map<String, double> spendingByCurrency;

  const CurrencyStats({
    required this.totalCurrencies,
    required this.mostUsedCurrency,
    required this.spendingByCurrency,
  });
}

// Provider for currency conversion service
final currencyConversionServiceProvider = Provider<CurrencyConversionService>((
  ref,
) {
  final expenseRepository = ref.read(expenseRepositoryProvider);
  return CurrencyConversionService(expenseRepository, ExchangeRateService());
});

// Provider for currency stats
final currencyStatsProvider = FutureProvider<CurrencyStats>((ref) async {
  final service = ref.read(currencyConversionServiceProvider);
  final expenseRepository = ref.read(expenseRepositoryProvider);
  final expenses = await expenseRepository.getAllExpenses();
  return service.getCurrencyStats(expenses);
});
